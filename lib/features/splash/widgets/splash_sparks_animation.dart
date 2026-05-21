import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SplashSparksAnimation extends StatefulWidget {
  const SplashSparksAnimation({super.key});

  @override
  State<SplashSparksAnimation> createState() => _SplashSparksAnimationState();
}

class _SplashSparksAnimationState extends State<SplashSparksAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SparksPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _SparkParticle {
  const _SparkParticle({
    required this.x,
    required this.delay,
    required this.size,
    required this.drift,
  });

  final double x;
  final double delay;
  final double size;
  final double drift;
}

class _SparksPainter extends CustomPainter {
  const _SparksPainter({required this.progress});

  final double progress;

  static const particles = [
    _SparkParticle(x: 0.24, delay: 0.00, size: 2.8, drift: -0.08),
    _SparkParticle(x: 0.34, delay: 0.18, size: 3.8, drift: 0.05),
    _SparkParticle(x: 0.42, delay: 0.36, size: 2.4, drift: -0.03),
    _SparkParticle(x: 0.52, delay: 0.08, size: 4.2, drift: 0.07),
    _SparkParticle(x: 0.61, delay: 0.28, size: 3.0, drift: -0.05),
    _SparkParticle(x: 0.72, delay: 0.48, size: 2.6, drift: 0.04),
    _SparkParticle(x: 0.80, delay: 0.68, size: 3.4, drift: -0.08),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final fireLine = size.height * 0.75;

    for (var i = 0; i < particles.length; i++) {
      final particle = particles[i];
      final localProgress = (progress + particle.delay) % 1;
      final opacity = (1 - localProgress).clamp(0, 1).toDouble();
      final x =
          size.width * particle.x +
          math.sin(localProgress * math.pi * 2) * size.width * particle.drift;
      final y = fireLine - (size.height * 0.52 * localProgress);

      paint.color = (i.isEven ? AppColors.primaryYellow : AppColors.fireOrange)
          .withValues(alpha: opacity * 0.9);
      canvas.drawCircle(Offset(x, y), particle.size, paint);

      paint.color = AppColors.primaryYellow.withValues(alpha: opacity * 0.2);
      canvas.drawCircle(Offset(x, y), particle.size * 2.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparksPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
