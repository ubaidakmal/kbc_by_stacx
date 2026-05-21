import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SplashSmokeAnimation extends StatefulWidget {
  const SplashSmokeAnimation({
    required this.width,
    required this.height,
    super.key,
  });

  final double width;
  final double height;

  @override
  State<SplashSmokeAnimation> createState() => _SplashSmokeAnimationState();
}

class _SplashSmokeAnimationState extends State<SplashSmokeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SmokePainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _SmokePainter extends CustomPainter {
  const _SmokePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    const delays = [0.0, 0.2, 0.4, 0.62, 0.78];

    for (var i = 0; i < delays.length; i++) {
      final localProgress = (progress + delays[i]) % 1;
      final fade = math.sin(localProgress * math.pi).clamp(0, 1).toDouble();
      final rise = size.height * localProgress;
      final drift =
          math.sin((localProgress * math.pi * 2) + i) * size.width * 0.12;
      final radius = size.width * (0.08 + localProgress * 0.08);
      final center = Offset(size.width * 0.5 + drift, size.height - rise);

      paint.color = AppColors.cream.withValues(alpha: 0.08 + (fade * 0.18));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SmokePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
