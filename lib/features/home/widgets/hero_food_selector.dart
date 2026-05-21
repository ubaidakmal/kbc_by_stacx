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
    final width = compact ? 310.0 : 390.0;
    final height = compact ? 160.0 : 230.0;
    final positions = compact
        ? const [Offset(16, 44), Offset(118, 12), Offset(220, 44)]
        : const [Offset(22, 96), Offset(150, 22), Offset(280, 96)];

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
                        begin: -1.1,
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
      ..moveTo(size.width * 0.15, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.04,
        size.width * 0.85,
        size.height * 0.72,
      );

    final pathMetric = path.computeMetrics().first;
    final dotPaint = Paint()
      ..color = AppColors.splashTextYellow.withValues(alpha: 0.34)
      ..style = PaintingStyle.fill;

    for (var i = 0; i <= 24; i++) {
      final distance = pathMetric.length * (i / 24);
      final tangent = pathMetric.getTangentForOffset(distance);
      if (tangent == null) continue;
      final pulse = math.sin((i / 24) * math.pi);
      canvas.drawCircle(tangent.position, 2.2 + pulse * 1.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedFoodPathPainter oldDelegate) {
    return oldDelegate.compact != compact;
  }
}
