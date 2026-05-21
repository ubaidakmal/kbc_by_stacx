import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../view_model/splash_view_model.dart';

class SplashLoadingText extends StatefulWidget {
  const SplashLoadingText({super.key});

  @override
  State<SplashLoadingText> createState() => _SplashLoadingTextState();
}

class _SplashLoadingTextState extends State<SplashLoadingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.select<SplashViewModel, double>(
      (viewModel) => viewModel.progress,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final dotCount = (_controller.value * 4).floor().clamp(0, 3);
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppConstants.splashLoadingLabel,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.splashTextPrimary.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: '.' * dotCount,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.splashTextYellow,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            width: 132,
            height: 4,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.splashYellowGlow.withValues(
                alpha: 0.12,
              ),
              color: AppColors.splashYellowGlow,
            ),
          ),
        ),
      ],
    );
  }
}
