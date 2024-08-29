// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

/// Inspect Google Maps state using the platform SDK.
///
/// This class is primarily used for testing. The methods on this
/// class should call "getters" on the GoogleMap object or equivalent
/// on the platform side.
class GoogleMapInspector {
  GoogleMapInspector(this._channel);

  final MethodChannel _channel;

  Future<bool> isCompassEnabled() async {
    return await _channel.invokeMethod<bool>('map#isCompassEnabled') ?? false;
  }

  Future<bool> isMapToolbarEnabled() async {
    return await _channel.invokeMethod<bool>('map#isMapToolbarEnabled') ?? false;
  }

  Future<MinMaxZoomPreference> getMinMaxZoomLevels() async {
    final List<double> zoomLevels =
        (await _channel.invokeMethod<List<dynamic>>('map#getMinMaxZoomLevels'))!
            .cast<double>();
    return MinMaxZoomPreference(zoomLevels[0], zoomLevels[1]);
  }

  Future<bool> isZoomGesturesEnabled() async {
    return await _channel.invokeMethod<bool>('map#isZoomGesturesEnabled') ?? false;
  }

  Future<bool> isRotateGesturesEnabled() async {
    return await _channel.invokeMethod<bool>('map#isRotateGesturesEnabled') ?? false;
  }

  Future<bool> isTiltGesturesEnabled() async {
    return await _channel.invokeMethod<bool>('map#isTiltGesturesEnabled') ?? false;
  }

  Future<bool> isScrollGesturesEnabled() async {
    return await _channel.invokeMethod<bool>('map#isScrollGesturesEnabled') ?? false;
  }

  Future<bool> isMyLocationButtonEnabled() async {
    return await _channel.invokeMethod<bool>('map#isMyLocationButtonEnabled') ?? false;
  }

  Future<bool> isTrafficEnabled() async {
    return await _channel.invokeMethod<bool>('map#isTrafficEnabled') ?? false;
  }

  Future<bool> isBuildingsEnabled() async {
    return await _channel.invokeMethod<bool>('map#isBuildingsEnabled') ?? false;
  }
}
