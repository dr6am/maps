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

import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';
import 'package:meta/meta.dart';
import 'package:web_browser/web_browser.dart';

import 'bing_maps_impl_default.dart'
    if (dart.library.html) 'bing_maps_impl_browser.dart';
import 'internal/static.dart';

/// Enables [MapWidget] to use [Bing Maps Custom Map URLs](https://docs.microsoft.com/en-us/bingmaps/articles/create-a-custom-map-url).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const BingMapsIframeAdapter(
///     apiKey: 'YOUR API KEY',
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class BingMapsIframeAdapter extends MapAdapter {
  const BingMapsIframeAdapter();

  @override
  String get productName => 'Bing Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    final sb = StringBuffer();
    final camera = widget.camera;
    final width = widget.size.width.toInt();
    final height = widget.size.height.toInt();

    // Base URL
    sb.write('https://www.bing.com/maps/embed');

    // Size
    sb.write('?h=');
    sb.write(height.toInt());
    sb.write('&w=');
    sb.write(width.toInt());

    // Location
    final geoPoint = camera.geoPoint;
    final query = camera.query;
    if (geoPoint != null && geoPoint.isValid) {
      // GeoPoint
      sb.write('&cp=');
      sb.write(geoPoint.latitude);
      sb.write('~');
      sb.write(geoPoint.longitude);
    } else if (query != null) {
      // Query
      sb.write('&where1=');
      sb.write(Uri.encodeQueryComponent(query));
    }

    // Zoom
    sb.write('&lvl=');
    sb.write(camera.zoom);

    // Other
    sb.write('&typ=d&sty=r&src=SHELL&FORM=MBEDV8');

    return WebBrowser(
      // URL
      initialUrl: sb.toString(),

      // No navigation buttons
      interactionSettings: null,

      // Javascript required
      javascriptEnabled: true,
    );
  }
}

/// Enables [MapWidget] to use [Bing Maps Javascript API](https://docs.microsoft.com/en-us/bingmaps/v8-web-control/).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const BingMapsJsAdapter(
///     apiKey: 'YOUR API KEY',
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class BingMapsJsAdapter extends MapAdapter {
  final String apiKey;

  const BingMapsJsAdapter({@required this.apiKey}) : assert(apiKey != null);

  @override
  String get productName => 'Bing Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    return buildBingMapsJs(this, widget);
  }
}

/// Enables [MapWidget] to use [Bing Maps REST API for static maps](https://docs.microsoft.com/en-us/bingmaps/rest-services/imagery/get-a-static-map).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const BingMapsStaticAdapter(
///     apiKey: 'YOUR API KEY',
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
///
/// It's also possible to specify map engine for individual [MapWidget]
/// instances:
/// ```
/// const widget = MapWidget(
///   engine: BingMapsStaticAdapter(
///     apiKey: 'YOUR API KEY',
///   ),
///   query: 'Paris',
/// );
/// ```
class BingMapsStaticAdapter extends MapAdapter {
  final String apiKey;

  const BingMapsStaticAdapter({
    @required this.apiKey,
  }) : assert(apiKey != null);

  @override
  String get productName => 'Bing Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    final camera = widget.camera;
    final sb = StringBuffer();

    // Base URL
    sb.write(
      'https://dev.virtualearth.net/REST/v1/Imagery/Map/imagerySet/centerPoint/zoomLevel',
    );

    // Size
    final size = widget.size;
    sb.write('?size=');
    sb.write(size.width.toInt());
    sb.write(',');
    sb.write(size.height.toInt());

    // Query or GeoPoint
    final query = camera.query ?? '';
    final geoPoint = camera.geoPoint;
    if (geoPoint != null && geoPoint.isValid) {
      sb.write('&centerPoint=');
      sb.write(geoPoint.latitude);
      sb.write(',');
      sb.write(geoPoint.longitude);
    } else if (query.isNotEmpty) {
      sb.write('&query=');
      sb.write(Uri.encodeQueryComponent(query));
    }

    // Zoom
    final zoom = camera.zoom;
    if (zoom != null) {
      sb.write('&lvl=');
      sb.write(zoom.toInt().clamp(0, 20));
    }

    // API key
    sb.write('&key=');
    sb.write(Uri.encodeQueryComponent(apiKey));

    return buildStaticMapWidget(
      mapWidget: widget,
      mapAdapterClassName: 'BingMapsStaticApi',
      src: sb.toString(),
    );
  }
}
