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

/// Cross-platform maps widgets. Supports Apple Maps and Google Maps.
///
/// Flutter widgets in this library are:
///   * [MapWidget]
library maps;

export 'package:database/database.dart' show GeoPoint;

export 'src/adapters/apple_maps.dart';
export 'src/adapters/bing_maps.dart';
export 'src/adapters/google_maps.dart';
export 'src/map_adapter.dart';
export 'src/map_circle.dart';
export 'src/map_launcher.dart';
export 'src/map_line.dart';
export 'src/map_location.dart';
export 'src/map_marker.dart';
export 'src/map_type.dart';
export 'src/map_widget.dart';
