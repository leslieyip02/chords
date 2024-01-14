import 'dart:math';
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
    this.synthesizer,
    this.sourceData,
  );

  final Synthesizer synthesizer;
  List<int> sourceData;

  static Future<SoundFontSource> fromPath(String path) async {
    String path = 'assets/soundfonts/organ.sf2';
    ByteData bytes = await rootBundle.load(path);
    Synthesizer synthesizer = Synthesizer.loadByteData(
      bytes,
      SynthesizerSettings(
        sampleRate: sampleRate,
        blockSize: 64,
        maximumPolyphony: 64,
        enableReverbAndChorus: true,
      ),
    );
    return SoundFontSource(synthesizer, []);
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
    int channel = 0,
    int preset = 0,
  }) {
    if (sourceData.isEmpty) {
      appendWavHeader();
    }

    // time in seconds
    int length = (duration * sampleRate).round();
    Uint8List uint8Buffer = Uint8List(length);
    synthesizer.selectPreset(channel: channel, preset: preset);
    for (final note in notes) {
      synthesizer.noteOn(
        channel: channel,
        key: note.key,
        velocity: note.velocity,
      );
    }

    List<double> doubleBuffer = List.filled(length * 2, 0);
    synthesizer.renderMono(doubleBuffer);
    synthesizer.noteOffAll();

    double minFrequency = double.infinity;
    double maxFrequency = -double.infinity;
    for (int i = 0; i < length; i++) {
      minFrequency = min(doubleBuffer[i], minFrequency);
      maxFrequency = max(doubleBuffer[i], maxFrequency);
    }

    double frequencyRange = maxFrequency - minFrequency;
    for (int i = 0; i < length; i++) {
      double sample = (doubleBuffer[i] + minFrequency) / frequencyRange;
      uint8Buffer[i] = (sample * compression).toInt();
    }
    sourceData.addAll(uint8Buffer);
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
