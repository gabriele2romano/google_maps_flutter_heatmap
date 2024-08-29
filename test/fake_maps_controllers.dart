// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

class FakePlatformGoogleMap {
  FakePlatformGoogleMap(int id, Map<dynamic, dynamic> params) {
    cameraPosition = CameraPosition.fromMap(params['initialCameraPosition'])!;
    channel = MethodChannel(
        'plugins.flutter.io/google_maps_$id', const StandardMethodCodec());
    channel.setMockMethodCallHandler(onMethodCall);
    updateOptions(params['options']);
    updateMarkers(params);
    updatePolygons(params);
    updatePolylines(params);
    updateCircles(params);
    updateHeatmaps(params);
  }

  late MethodChannel channel;

  late CameraPosition cameraPosition;

  late bool compassEnabled;

  late bool mapToolbarEnabled;

  late CameraTargetBounds cameraTargetBounds;

  late MapType mapType;

  late MinMaxZoomPreference minMaxZoomPreference;

  late bool rotateGesturesEnabled;

  late bool scrollGesturesEnabled;

  late bool tiltGesturesEnabled;

  late bool zoomGesturesEnabled;

  late bool trackCameraPosition;

  late bool myLocationEnabled;

  late bool trafficEnabled;

  late bool buildingsEnabled;

  late bool myLocationButtonEnabled;

  late List<dynamic> padding;

  late Set<MarkerId> markerIdsToRemove;

  late Set<Marker> markersToAdd;

  late Set<Marker> markersToChange;

  late Set<PolygonId> polygonIdsToRemove;

  late Set<Polygon> polygonsToAdd;

  late Set<Polygon> polygonsToChange;

  late Set<PolylineId> polylineIdsToRemove;

  late Set<Polyline> polylinesToAdd;

  late Set<Polyline> polylinesToChange;

  late Set<CircleId> circleIdsToRemove;

  late Set<Circle> circlesToAdd;

  late Set<Circle> circlesToChange;

  late Set<HeatmapId> heatmapIdsToRemove;

  late Set<Heatmap> heatmapsToAdd;

  late Set<Heatmap> heatmapsToChange;

  Future<dynamic> onMethodCall(MethodCall call) {
    switch (call.method) {
      case 'map#update':
        updateOptions(call.arguments['options']);
        return Future<void>.sync(() {});
      case 'markers#update':
        updateMarkers(call.arguments);
        return Future<void>.sync(() {});
      case 'polygons#update':
        updatePolygons(call.arguments);
        return Future<void>.sync(() {});
      case 'polylines#update':
        updatePolylines(call.arguments);
        return Future<void>.sync(() {});
      case 'circles#update':
        updateCircles(call.arguments);
        return Future<void>.sync(() {});
      case 'heatmaps#update':
        updateHeatmaps(call.arguments);
        return Future<void>.sync(() {});
      default:
        return Future<void>.sync(() {});
    }
  }

  void updateMarkers(Map<dynamic, dynamic> markerUpdates) {
    markersToAdd = _deserializeMarkers(markerUpdates['markersToAdd']);
    markerIdsToRemove =
        _deserializeMarkerIds(markerUpdates['markerIdsToRemove']);
    markersToChange = _deserializeMarkers(markerUpdates['markersToChange']);
  }

  Set<MarkerId> _deserializeMarkerIds(List<dynamic> markerIds) {
    return markerIds.map((dynamic markerId) => MarkerId(markerId)).toSet();
  }

  Set<Marker> _deserializeMarkers(dynamic markers) {
    if (markers == null) {
      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
      // https://github.com/flutter/flutter/issues/28312
      // ignore: prefer_collection_literals
      return Set<Marker>();
    }
    final List<dynamic> markersData = markers;
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    final Set<Marker> result = Set<Marker>();
    for (Map<dynamic, dynamic> markerData in markersData) {
      final String markerId = markerData['markerId'];
      final double alpha = markerData['alpha'];
      final bool draggable = markerData['draggable'];
      final bool visible = markerData['visible'];

      final dynamic infoWindowData = markerData['infoWindow'];
      InfoWindow infoWindow = InfoWindow.noText;
      if (infoWindowData != null) {
        final Map<dynamic, dynamic> infoWindowMap = infoWindowData;
        infoWindow = InfoWindow(
          title: infoWindowMap['title'],
          snippet: infoWindowMap['snippet'],
        );
      }

      result.add(Marker(
        markerId: MarkerId(markerId),
        draggable: draggable,
        visible: visible,
        infoWindow: infoWindow,
        alpha: alpha,
      ));
    }

    return result;
  }

  void updatePolygons(Map<dynamic, dynamic> polygonUpdates) {
    polygonsToAdd = _deserializePolygons(polygonUpdates['polygonsToAdd']);
    polygonIdsToRemove =
        _deserializePolygonIds(polygonUpdates['polygonIdsToRemove']);
    polygonsToChange = _deserializePolygons(polygonUpdates['polygonsToChange']);
  }

  Set<PolygonId> _deserializePolygonIds(List<dynamic> polygonIds) {
    return polygonIds.map((dynamic polygonId) => PolygonId(polygonId)).toSet();
  }

  Set<Polygon> _deserializePolygons(dynamic polygons) {
    if (polygons == null) {
      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
      // https://github.com/flutter/flutter/issues/28312
      // ignore: prefer_collection_literals
      return Set<Polygon>();
    }
    final List<dynamic> polygonsData = polygons;
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    final Set<Polygon> result = Set<Polygon>();
    for (Map<dynamic, dynamic> polygonData in polygonsData) {
      final String polygonId = polygonData['polygonId'];
      final bool visible = polygonData['visible'];
      final bool geodesic = polygonData['geodesic'];
      final List<LatLng> points = _deserializePoints(polygonData['points']);

      result.add(Polygon(
        polygonId: PolygonId(polygonId),
        visible: visible,
        geodesic: geodesic,
        points: points,
      ));
    }

    return result;
  }

  List<LatLng> _deserializePoints(List<dynamic> points) {
    return points.map<LatLng>((dynamic list) {
      return LatLng(list[0], list[1]);
    }).toList();
  }

  void updatePolylines(Map<dynamic, dynamic> polylineUpdates) {
    polylinesToAdd = _deserializePolylines(polylineUpdates['polylinesToAdd']);
    polylineIdsToRemove =
        _deserializePolylineIds(polylineUpdates['polylineIdsToRemove']);
    polylinesToChange =
        _deserializePolylines(polylineUpdates['polylinesToChange']);
  }

  Set<PolylineId> _deserializePolylineIds(List<dynamic> polylineIds) {
    return polylineIds
        .map((dynamic polylineId) => PolylineId(polylineId))
        .toSet();
  }

  Set<Polyline> _deserializePolylines(dynamic polylines) {
    if (polylines == null) {
      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
      // https://github.com/flutter/flutter/issues/28312
      // ignore: prefer_collection_literals
      return Set<Polyline>();
    }
    final List<dynamic> polylinesData = polylines;
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    final Set<Polyline> result = Set<Polyline>();
    for (Map<dynamic, dynamic> polylineData in polylinesData) {
      final String polylineId = polylineData['polylineId'];
      final bool visible = polylineData['visible'];
      final bool geodesic = polylineData['geodesic'];
      final List<LatLng> points = _deserializePoints(polylineData['points']);

      result.add(Polyline(
        polylineId: PolylineId(polylineId),
        visible: visible,
        geodesic: geodesic,
        points: points,
      ));
    }

    return result;
  }

  void updateCircles(Map<dynamic, dynamic> circleUpdates) {
    circlesToAdd = _deserializeCircles(circleUpdates['circlesToAdd']);
    circleIdsToRemove =
        _deserializeCircleIds(circleUpdates['circleIdsToRemove']);
    circlesToChange = _deserializeCircles(circleUpdates['circlesToChange']);
  }

  Set<CircleId> _deserializeCircleIds(List<dynamic> circleIds) {
    return circleIds.map((dynamic circleId) => CircleId(circleId)).toSet();
  }

  Set<Circle> _deserializeCircles(dynamic circles) {
    if (circles == null) {
      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
      // https://github.com/flutter/flutter/issues/28312
      // ignore: prefer_collection_literals
      return Set<Circle>();
    }
    final List<dynamic> circlesData = circles;
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    final Set<Circle> result = Set<Circle>();
    for (Map<dynamic, dynamic> circleData in circlesData) {
      final String circleId = circleData['circleId'];
      final bool visible = circleData['visible'];
      final double radius = circleData['radius'];

      result.add(Circle(
        circleId: CircleId(circleId),
        visible: visible,
        radius: radius,
      ));
    }

    return result;
  }

  List<WeightedLatLng> _deserializeWeightedPoints(List<dynamic> points) {
    return points.map<WeightedLatLng>((dynamic list) {
      return WeightedLatLng(
          point: LatLng(list[0][0], list[0][1]), intensity: list[1]);
    }).toList();
  }

  void updateHeatmaps(Map<dynamic, dynamic> heatmapUpdates) {
    heatmapsToAdd = _deserializeHeatmaps(heatmapUpdates['heatmapsToAdd']);
    heatmapIdsToRemove =
        _deserializeHeatmapIds(heatmapUpdates['heatmapIdsToRemove']);
    heatmapsToChange = _deserializeHeatmaps(heatmapUpdates['heatmapsToChange']);
  }

  Set<HeatmapId> _deserializeHeatmapIds(List<dynamic> heatmapIds) {
    return heatmapIds.map((dynamic heatmapId) => HeatmapId(heatmapId)).toSet();
  }

  Set<Heatmap> _deserializeHeatmaps(dynamic heatmaps) {
    if (heatmaps == null) {
      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
      // https://github.com/flutter/flutter/issues/28312
      // ignore: prefer_collection_literals
      return Set<Heatmap>();
    }
    final List<dynamic> heatmapsData = heatmaps;
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    final Set<Heatmap> result = Set<Heatmap>();
    for (Map<dynamic, dynamic> heatmapData in heatmapsData) {
      final String heatmapId = heatmapData['heatmapId'];
      final bool visible = heatmapData['visible'];
      final double opacity = heatmapData['opacity'];
      final List<WeightedLatLng> points =
          _deserializeWeightedPoints(heatmapData['points']);

      result.add(Heatmap(
        heatmapId: HeatmapId(heatmapId),
        visible: visible,
        opacity: opacity,
        points: points,
      ));
    }

    return result;
  }

  void updateOptions(Map<dynamic, dynamic> options) {
    if (options.containsKey('compassEnabled')) {
      compassEnabled = options['compassEnabled'];
    }
    if (options.containsKey('mapToolbarEnabled')) {
      mapToolbarEnabled = options['mapToolbarEnabled'];
    }
    if (options.containsKey('cameraTargetBounds')) {
      final List<dynamic> boundsList = options['cameraTargetBounds'];
      cameraTargetBounds = boundsList[0] == null
          ? CameraTargetBounds.unbounded
          : CameraTargetBounds(LatLngBounds.fromList(boundsList[0]));
    }
    if (options.containsKey('mapType')) {
      mapType = MapType.values[options['mapType']];
    }
    if (options.containsKey('minMaxZoomPreference')) {
      final List<dynamic> minMaxZoomList = options['minMaxZoomPreference'];
      minMaxZoomPreference =
          MinMaxZoomPreference(minMaxZoomList[0], minMaxZoomList[1]);
    }
    if (options.containsKey('rotateGesturesEnabled')) {
      rotateGesturesEnabled = options['rotateGesturesEnabled'];
    }
    if (options.containsKey('scrollGesturesEnabled')) {
      scrollGesturesEnabled = options['scrollGesturesEnabled'];
    }
    if (options.containsKey('tiltGesturesEnabled')) {
      tiltGesturesEnabled = options['tiltGesturesEnabled'];
    }
    if (options.containsKey('trackCameraPosition')) {
      trackCameraPosition = options['trackCameraPosition'];
    }
    if (options.containsKey('zoomGesturesEnabled')) {
      zoomGesturesEnabled = options['zoomGesturesEnabled'];
    }
    if (options.containsKey('myLocationEnabled')) {
      myLocationEnabled = options['myLocationEnabled'];
    }
    if (options.containsKey('myLocationButtonEnabled')) {
      myLocationButtonEnabled = options['myLocationButtonEnabled'];
    }
    if (options.containsKey('trafficEnabled')) {
      trafficEnabled = options['trafficEnabled'];
    }
    if (options.containsKey('buildingsEnabled')) {
      buildingsEnabled = options['buildingsEnabled'];
    }
    if (options.containsKey('padding')) {
      padding = options['padding'];
    }
  }
}

class FakePlatformViewsController {
  late FakePlatformGoogleMap? lastCreatedView;

  Future<dynamic> fakePlatformViewsMethodHandler(MethodCall call) {
    switch (call.method) {
      case 'create':
        final Map<dynamic, dynamic> args = call.arguments;
        final Map<dynamic, dynamic> params = _decodeParams(args['params']);
        lastCreatedView = FakePlatformGoogleMap(
          args['id'],
          params,
        );
        return Future<int>.sync(() => 1);
      default:
        return Future<void>.sync(() {});
    }
  }

  void reset() {
    lastCreatedView = null;
  }
}

Map<dynamic, dynamic> _decodeParams(Uint8List paramsMessage) {
  final ByteBuffer buffer = paramsMessage.buffer;
  final ByteData messageBytes = buffer.asByteData(
    paramsMessage.offsetInBytes,
    paramsMessage.lengthInBytes,
  );
  return const StandardMessageCodec().decodeMessage(messageBytes);
}
