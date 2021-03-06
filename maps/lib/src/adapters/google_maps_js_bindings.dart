// Copyright 2020 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@JS('google.maps')
library google_maps_js;

import 'dart:html' as html;

import 'package:js/js.dart';

bool get isLoaded {
  try {
    return _map != null;
  } catch (e) {
    return false;
  }
}

@JS('Map')
external Object get _map;

@JS()
class LatLng {
  external factory LatLng(double lat, double lng);
}

@JS('Map')
class Map {
  external factory Map(html.Element element, [MapArgs args]);
}

@JS()
@anonymous
class MapArgs {
  external factory MapArgs({
    LatLng center,
    int zoom,
  });
}

@JS('Marker')
class Marker {
  external factory Marker({
    LatLng position,
    String map,
    String title,
  });

  external void setMap(Map map);
}
