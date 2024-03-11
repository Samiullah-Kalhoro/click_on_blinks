import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeso_flutter/event/user_status_info.dart';
import 'package:seeso_flutter/seeso.dart';
import 'package:seeso_flutter/seeso_initialized_result.dart';

class BlinkCubit extends Cubit<Map<String, int>> {
  final _seesoPlugin = SeeSo();
  static const String _licenseKey =
      "dev_ve9xuqvnxtol53w0jmlmf4euqpykvgj6vwwotre9";
  bool _hasCameraPermission = false;
  DateTime? _lastBlinkTime;
  DateTime? _lastLeftBlinkTime;
  DateTime? _lastRightBlinkTime;

  BlinkCubit() : super({'isBlink': 0, 'isBlinkLeft': 0, 'isBlinkRight': 0}) {
    initSeeSo();
  }

  Future<void> checkCameraPermission() async {
    _hasCameraPermission = await _seesoPlugin.checkCameraPermission();
    if (!_hasCameraPermission) {
      _hasCameraPermission = await _seesoPlugin.requestCameraPermission();
    }
    if (!state['isBlink']!.isNegative ||
        !state['isBlinkLeft']!.isNegative ||
        !state['isBlinkRight']!.isNegative) {
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

          _seesoPlugin.startTracking();
        }

        listenEvents();
        debugPrint("Already initialized SeeSo plugin");
        _seesoPlugin.startTracking();
      } on PlatformException catch (e) {
        if (e.message == "ALREADY_EXISTS") {
          listenEvents();

          debugPrint("Already initialized SeeSo plugin");
          _seesoPlugin.startTracking();
        }
      }
    }
  }

  void listenEvents() {
    _seesoPlugin.getUserStatusEvent().listen((event) {
      UserStatusInfo userStatusInfo = UserStatusInfo(event);

      if (userStatusInfo.type == UserStatusEventType.BLINK) {
        // for leftblink
        if (userStatusInfo.isBlinkLeft == true &&
            userStatusInfo.isBlinkRight == false &&
            userStatusInfo.isBlink == false) {
          if (_lastLeftBlinkTime == null ||
              DateTime.now().difference(_lastLeftBlinkTime!) >
                  const Duration(milliseconds: 1500)) {
            final newCount = {
              'isBlink': state['isBlink']!,
              'isBlinkLeft': state['isBlinkLeft']! + 1,
              'isBlinkRight': state['isBlinkRight']!
            };
            emit(newCount);
            _lastLeftBlinkTime = DateTime.now();
          }
        }

        // for rightblink
        else if (userStatusInfo.isBlinkRight == true &&
            userStatusInfo.isBlinkLeft == false &&
            userStatusInfo.isBlink == false) {
          if (_lastRightBlinkTime == null ||
              DateTime.now().difference(_lastRightBlinkTime!) >
                  const Duration(milliseconds: 1500)) {
            final newCount = {
              'isBlink': state['isBlink']!,
              'isBlinkLeft': state['isBlinkLeft']!,
              'isBlinkRight': state['isBlinkRight']! + 1
            };
            emit(newCount);
            _lastRightBlinkTime = DateTime.now();
          }
        } else if (userStatusInfo.isBlink == true &&
            userStatusInfo.isBlinkLeft == true &&
            userStatusInfo.isBlinkRight == true) {
          if (_lastBlinkTime == null ||
              DateTime.now().difference(_lastBlinkTime!) >
                  const Duration(milliseconds: 1500)) {
            final newCount = {
              'isBlink': state['isBlink']! + 1,
              'isBlinkLeft': state['isBlinkLeft']! + 1,
              'isBlinkRight': state['isBlinkRight']! + 1,
            };
            emit(newCount);
            _lastBlinkTime = DateTime.now();
          }
        }
      }
    });
  }

  void dispose() {
    _seesoPlugin.deinitGazeTracker();
  }
}

