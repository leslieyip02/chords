'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"manifest.json": "bede16446859fb5f2d9ea3c40fd70890",
"index.html": "f32fdf9364c0956acbbb4252c676c28e",
"/": "f32fdf9364c0956acbbb4252c676c28e",
"assets/AssetManifest.bin": "a329f9508a9825efb15b4e0a486a6384",
"assets/fonts/MaterialIcons-Regular.otf": "5ae244c0975a4b2a4fa3528f6457bcf3",
"assets/assets/favicon.png": "909ad71e2fbb478bc3843405d3603c55",
"assets/assets/sheets/all_of_me.txt": "ed9400df7d48feda6710db8e58148736",
"assets/assets/sheets/there_will_never_be_another_you.txt": "b9e6418ec5a3fb974efd8789198e1085",
"assets/assets/sheets/bag's_groove.txt": "1676999b5b6573633627590d87453e52",
"assets/assets/sheets/how_high_the_moon.txt": "3070033b816bcb5005a766ae210ccd67",
"assets/assets/sheets/it_could_happen_to_you.txt": "add8683f22ef8e3c048bab97305a22fd",
"assets/assets/sheets/autumn_leaves.txt": "84c83e8f2523da64a49dbeffe51b9ae9",
"assets/assets/sheets/the_girl_from_ipanema.txt": "a478930fd41acc779438f92d3148747a",
"assets/assets/sheets/blue_bossa.txt": "6edb83074440ceed9493322da40257ff",
"assets/assets/sheets/fly_me_to_the_moon.txt": "4af4328cae69783ccaf0fcb14f369702",
"assets/assets/sheets/cherokee.txt": "d438ea8bf24c61eaf9d857c9da0b3b93",
"assets/assets/sheets/mr_p.c..txt": "8cd0f59834de2d2b96471b8031ec1535",
"assets/assets/sheets/black_orpheus.txt": "9d24b3a33e512b7661ad4d8af912184a",
"assets/assets/sheets/corcovado.txt": "f66d673682ef033ea138eb3bd002280c",
"assets/assets/sheets/four.txt": "14bfea44e47f8a4cbf0f7557e019acb5",
"assets/assets/sheets/st._thomas.txt": "4d4245b04a1dd5505ce3883d25068146",
"assets/assets/sheets/days_of_wine_and_roses.txt": "9af157a23720fac2805e68911a71f4ac",
"assets/assets/sheets/just_friends.txt": "8e412636ed2643f793f70549ec1f9982",
"assets/assets/sheets/take_the_a_train.txt": "d6bc56fe6021ea845e816b4f32e9d57f",
"assets/assets/sheets/lady_bird.txt": "1bd9de5cd45a520a5c779a434e0d54dc",
"assets/assets/sheets/c_jam_blues.txt": "7cade0e3c9453551098d4e345388e504",
"assets/assets/sheets/someday_my_prince_will_come.txt": "34949fcd95e7ddec245ac6de2f1c6f98",
"assets/assets/sheets/mack_the_knife.txt": "e7ff9c815e5aeac5bf4004492b3acce9",
"assets/assets/sheets/misty.txt": "1267ffade051756f5b42f33ac3f1511e",
"assets/assets/sheets/all_blues.txt": "cc0ab0b28bfe7f097a36309bf8828fe0",
"assets/assets/sheets/what_is_this_thing_called_love.txt": "6200dfa600e216528c7a176b19138a96",
"assets/assets/sheets/caravan.txt": "9c29124e745b84023de6dc51e333f7c2",
"assets/assets/sheets/all_the_things_you_are.txt": "a5c3d73183f7f2e6fd8e1adc4dd5635e",
"assets/assets/sheets/but_not_for_me.txt": "aa46001a2c008d48ea1862ec72515551",
"assets/assets/sheets/on_green_dolphin_street.txt": "da4fe84e81f55c9a25c91145b7eee99f",
"assets/assets/sheets/georgia_on_my_mind.txt": "d7e56d1a2cbaadcda3e1c79e5b5f57cf",
"assets/assets/sheets/on_the_sunny_side_of_the_street.txt": "da4816b592f71999a5987b50316dea19",
"assets/assets/sheets/take_five.txt": "424334175dce3875a66dde7456dcaefe",
"assets/AssetManifest.bin.json": "5410adde3ab5adcfd958f69b364590f0",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "c643541ca3730c35197c2886b2c7c69f",
"assets/AssetManifest.json": "eaffda9f9fb0229a6a12e7a32b01814e",
"favicon.png": "909ad71e2fbb478bc3843405d3603c55",
"main.dart.js": "b491e4d3048d5dae0473b03e9dbb6f4b",
"version.json": "7a2673f71b441dbf13957c333c9e3d55",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
