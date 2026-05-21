import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';

class SplashCookingPot extends StatefulWidget {
  const SplashCookingPot({required this.width, super.key});

  final double width;

  @override
  State<SplashCookingPot> createState() => _SplashCookingPotState();
}

class _SplashCookingPotState extends State<SplashCookingPot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final wave = Curves.easeInOut.transform(_controller.value);
        final yOffset = math.sin(wave * math.pi) * -8;
        final rotation = math.sin(wave * math.pi * 2) * 0.012;

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Transform.rotate(angle: rotation, child: child),
        );
      },
      child: SizedBox(
        width: widget.width,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [

            Image.asset(
              AppImages.cookingPot,
              width: widget.width,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
