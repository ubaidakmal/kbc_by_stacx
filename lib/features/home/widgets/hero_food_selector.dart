import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../view_model/home_view_model.dart';
import 'hero_food_icon.dart';

class HeroFoodSelector extends StatelessWidget {
  const HeroFoodSelector({
    required this.animationStart,
    required this.iconDuration,
    required this.iconGap,
    this.compact = false,
    super.key,
  });

  final Duration animationStart;
  final Duration iconDuration;
  final Duration iconGap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final visibleIndices = viewModel.visibleFoodIndices;
    final width = compact ? 118.0 : 168.0;
    final height = compact ? 330.0 : 500.0;
    final positions = compact
        ? const [Offset(50, 10), Offset(-32, 132), Offset(50, 254)]
        : const [Offset(82, 28), Offset(-30, 214), Offset(82, 400)];

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _CurvedFoodPathPainter(compact: compact),
            ),
          ),
          for (var slot = 0; slot < visibleIndices.length; slot++)
            AnimatedPositioned(
              key: ValueKey(visibleIndices[slot]),
              duration: const Duration(milliseconds: 460),
              curve: Curves.easeOutCubic,
              left: positions[slot].dx,
              top: positions[slot].dy,
              child:
                  HeroFoodIcon(
                        item: viewModel.foodItems[visibleIndices[slot]],
                        isActive:
                            visibleIndices[slot] == viewModel.selectedFoodIndex,
                        onTap: () => viewModel.selectFood(visibleIndices[slot]),
                      )
                      .animate()
                      .fadeIn(
                        delay: animationStart + (iconGap * slot),
                        duration: iconDuration,
                        curve: Curves.easeOutCubic,
                      )
                      .slideY(
                        begin: -2.8,
                        end: 0,
                        delay: animationStart + (iconGap * slot),
                        duration: iconDuration,
                        curve: Curves.easeOutBack,
                      ),
            ),
        ],
      ),
    );
  }
}

class _CurvedFoodPathPainter extends CustomPainter {
  const _CurvedFoodPathPainter({required this.compact});

  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.78, size.height * 0.09)
      ..cubicTo(
        -size.width * 0.2,
        size.height * 0.26,
        -size.width * 0.2,
        size.height * 0.74,
        size.width * 0.78,
        size.height * 0.91,
      );

    final pathMetric = path.computeMetrics().first;
    final dotPaint = Paint()
      ..color = AppColors.splashTextPrimary.withValues(alpha: 0.32)
      ..style = PaintingStyle.fill;

    for (var i = 0; i <= 32; i++) {
      final distance = pathMetric.length * (i / 32);
      final tangent = pathMetric.getTangentForOffset(distance);
      if (tangent == null) continue;
      final pulse = math.sin((i / 32) * math.pi);
      canvas.drawCircle(tangent.position, 1.8 + pulse * 0.8, dotPaint);
    }

    final linePaint = Paint()
      ..color = AppColors.splashTextYellow.withValues(alpha: 0.18)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.5),
      Offset(size.width * 0.72, size.height * 0.5),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CurvedFoodPathPainter oldDelegate) {
    return oldDelegate.compact != compact;
  }
}
