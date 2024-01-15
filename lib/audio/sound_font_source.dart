import 'dart:math';
import 'package:chords/audio/sheet_player.dart';
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';

class SoundFontSource extends StreamAudioSource {
  static const int chunkID = 0x52494646; // "RIFF"
  static const int chunkSize = 0x7fffffff;
  static const int format = 0x57415645; // "WAVE"
  static const int subchunk1ID = 0x666d7420; // "fmt"
  static const int subchunk1Size = 16;
  static const int audioFormat = 1;
  static const int numChannels = 1;
  static const int sampleRate = 44100;
  static const int byteRate = sampleRate * numChannels * bytesPerSample;
  static const int blockAlign = numChannels * bytesPerSample;
  static const int bitsPerSample = bytesPerSample * 8;
  static const int subchunk2ID = 0x64617461; // "data"
  static const int subchunk2Size = chunkSize;
  static const int headerSize = 44;
  static const int bytesPerSample = 1;
  static const int compression = 220;

  SoundFontSource(
    this.chordSynthesizer,
    this.metronomeSynthesizer,
    this.sourceData,
  );

  final Synthesizer chordSynthesizer;
  final Synthesizer metronomeSynthesizer;
  List<int> sourceData;

  static Future<Synthesizer> loadSynthesizer(String path) async {
    return rootBundle.load(path).then(
          (byteData) => Synthesizer.loadByteData(
            byteData,
            SynthesizerSettings(
              sampleRate: sampleRate,
              blockSize: 64,
              maximumPolyphony: 64,
              enableReverbAndChorus: true,
            ),
          ),
        );
  }

  static Future<SoundFontSource> fromSettings(
    SoundFontSettings chordSettings,
  ) async {
    Synthesizer chordSynthesizer = await SoundFontSource.loadSynthesizer(
      chordSettings.path,
    );
    Synthesizer metronomeSynthesizer = await SoundFontSource.loadSynthesizer(
      SheetPlayer.metronomePath,
    );
    metronomeSynthesizer.masterVolume = 0.7;
    return SoundFontSource(chordSynthesizer, metronomeSynthesizer, []);
  }

  void appendWavHeader() {
    Uint8List uint8Buffer = Uint8List(headerSize);
    ByteData buffer = uint8Buffer.buffer.asByteData();
    // with reference to http://soundfile.sapp.org/doc/WaveFormat/
    buffer.setUint32(0, chunkID, Endian.big);
    buffer.setUint32(4, chunkSize, Endian.little);
    buffer.setUint32(8, format, Endian.big);
    buffer.setUint32(12, subchunk1ID, Endian.big);
    buffer.setUint32(16, subchunk1Size, Endian.little);
    buffer.setUint16(20, audioFormat, Endian.little);
    buffer.setUint16(22, numChannels, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, byteRate, Endian.little);
    buffer.setUint16(32, blockAlign, Endian.little);
    buffer.setUint16(34, bitsPerSample, Endian.little);
    buffer.setUint32(36, subchunk2ID, Endian.big);
    buffer.setUint32(40, subchunk2Size, Endian.little);
    sourceData = List.from(uint8Buffer);
  }

  void appendNotes(
    Iterable<SoundFontNote> notes,
    double duration, {
    required SoundFontSettings chordSettings,
    int beats = 0,
    int beatLength = 512,
  }) {
    if (sourceData.isEmpty) {
      appendWavHeader();
    }

    // chords
    // time in seconds
    int length = (duration * sampleRate).round();
    Uint8List uint8Buffer = Uint8List(length);

    List<double> chordBuffer = List.filled(length * 2, 0);
    chordSynthesizer.selectPreset(
      channel: chordSettings.channel,
      preset: chordSettings.preset,
    );
    for (final note in notes) {
      chordSynthesizer.noteOn(
        channel: chordSettings.channel,
        key: note.key,
        velocity: note.velocity,
      );
    }
    chordSynthesizer.renderMono(chordBuffer);
    chordSynthesizer.noteOffAll();

    double minValue, valueRange;
    [minValue, valueRange] = amplitudeRange(chordBuffer);
    for (int i = 0; i < length; i++) {
      double sample = (chordBuffer[i] + minValue) / valueRange;
      uint8Buffer[i] = (sample * compression).toInt();
    }

    // metronome
    // magic numbers come from here:
    // https://www.polyphone-soundfonts.com/documents/22-unpitched-percussion/560-metronom
    if (beats != 0) {
      int interval = length ~/ beats;

      // downbeat
      List<double> beatBuffer = List.filled(beatLength * 2, 0);
      metronomeSynthesizer.selectPreset(channel: 0, preset: 0);
      metronomeSynthesizer.noteOn(channel: 0, key: 76, velocity: 127);
      metronomeSynthesizer.renderMono(beatBuffer);
      metronomeSynthesizer.noteOffAll();

      [minValue, valueRange] = amplitudeRange(beatBuffer);
      for (int i = 0; i < beatLength; i++) {
        double sample = (beatBuffer[i] + minValue) / valueRange;
        uint8Buffer[i] = (sample * compression).toInt();
      }

      // other beats
      metronomeSynthesizer.noteOn(channel: 0, key: 77, velocity: 80);
      metronomeSynthesizer.renderMono(beatBuffer);
      metronomeSynthesizer.noteOffAll();

      [minValue, valueRange] = amplitudeRange(beatBuffer);
      for (int i = 0; i < beatLength; i++) {
        double sample = (beatBuffer[i] + minValue) / valueRange;
        int value = (sample * compression).toInt();
        for (int j = 1; j < beats; j++) {
          uint8Buffer[interval * j + i] = value;
        }
      }
    }

    sourceData.addAll(uint8Buffer);
  }

  List<double> amplitudeRange(List<double> buffer) {
    double minFrequency = double.infinity;
    double maxFrequency = -double.infinity;
    for (int i = 0; i < buffer.length; i++) {
      minFrequency = min(buffer[i], minFrequency);
      maxFrequency = max(buffer[i], maxFrequency);
    }
    double frequencyRange = maxFrequency - minFrequency;
    return [minFrequency, frequencyRange];
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= sourceData.length;
    return StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: start,
      stream: Stream.value(sourceData.sublist(start, end)),
      contentType: 'audio/wav',
      rangeRequestsSupported: true,
    );
  }
}

class SoundFontNote {
  SoundFontNote(
    this.key,
    this.velocity,
  );

  // concert C is 60
  final int key;
  final int velocity;
}

class SoundFontSettings {
  SoundFontSettings(
    this.path, {
    this.channel = 0,
    this.preset = 0,
  });

  String path;
  int channel;
  int preset;
}
