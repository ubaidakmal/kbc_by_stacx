import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';

class SplashViewModel extends ChangeNotifier {
  Timer? _timer;
  bool _isLoading = true;
  double _progress = 0;
  bool _isDisposed = false;

  bool get isLoading => _isLoading;
  double get progress => _progress;

  void startSplash() {
    _timer?.cancel();
    _isLoading = true;
    _progress = 0;

    const tick = Duration(milliseconds: 80);
    final totalTicks = AppConstants.splashDuration.inMilliseconds / 80;
    var currentTick = 0;

    _timer = Timer.periodic(tick, (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      currentTick++;
      _progress = (currentTick / totalTicks).clamp(0, 1).toDouble();

      if (_progress >= 1) {
        _isLoading = false;
        timer.cancel();
      }

      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
