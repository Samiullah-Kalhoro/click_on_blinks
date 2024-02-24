import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeso_flutter/event/user_status_info.dart';
import 'package:seeso_flutter/seeso.dart';
import 'package:seeso_flutter/seeso_initialized_result.dart';

class BlinkCubit extends Cubit<int> {
  final _seesoPlugin = SeeSo();
  static const String _licenseKey =
      "dev_ve9xuqvnxtol53w0jmlmf4euqpykvgj6vwwotre9";
  bool _hasCameraPermission = false;
  DateTime? _lastBlinkTime;

  BlinkCubit() : super(0) {
    initSeeSo();
  }

  Future<void> checkCameraPermission() async {
    _hasCameraPermission = await _seesoPlugin.checkCameraPermission();
    if (!_hasCameraPermission) {
      _hasCameraPermission = await _seesoPlugin.requestCameraPermission();
    }
    if (!state.isNegative) {
      return;
    }
  }

  Future<void> initSeeSo() async {
    await checkCameraPermission();
    if (_hasCameraPermission) {
      try {
        InitializedResult? initializedResult = await _seesoPlugin
            .initGazeTracker(licenseKey: _licenseKey, useBlink: true);
        if (initializedResult!.result) {
          listenEvents();
          try {
            _seesoPlugin.startTracking();
          } on PlatformException catch (e) {
            debugPrint("Occur PlatformException (${e.message})");
          }
        }
      } on PlatformException catch (e) {
        debugPrint("Occur PlatformException (${e.message})");
      }
    }
  }

  void listenEvents() {
    _seesoPlugin.getUserStatusEvent().listen((event) {
      UserStatusInfo userStatusInfo = UserStatusInfo(event);
      if (userStatusInfo.type == UserStatusEventType.BLINK &&
          userStatusInfo.isBlink == true) {
        if (_lastBlinkTime == null ||
            DateTime.now().difference(_lastBlinkTime!) > const Duration(milliseconds: 500)) {
          emit(state + 1);
          _lastBlinkTime = DateTime.now();
        }
      }
    });
  }
}
