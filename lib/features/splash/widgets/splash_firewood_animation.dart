import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_animations.dart';

class SplashFirewoodAnimation extends StatelessWidget {
  const SplashFirewoodAnimation({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        AppAnimations.firewood,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}
