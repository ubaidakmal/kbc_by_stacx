import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';

class HeroAppBar extends StatelessWidget {
  const HeroAppBar({
    required this.animationDelay,
    required this.animationDuration,
    super.key,
  });

  final Duration animationDelay;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;

        return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: compact ? 360 : 920,
                      minHeight: 62,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 14 : 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackOverlay.withValues(alpha: 0.22),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: AppColors.splashTextYellow.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 34,
                          spreadRadius: 1,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.white.withValues(alpha: 0.16),
                          AppColors.white.withValues(alpha: 0.05),
                          AppColors.splashTextYellow.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            AppConstants.heroBrandName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.splashTextPrimary,
                              fontSize: compact ? 17 : 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (!compact) ...[
                          const SizedBox(width: 30),
                          const _NavItem('Home'),
                          const _NavItem('Menu'),
                          const _NavItem('Catering'),
                          const _NavItem('Contact'),
                          const SizedBox(width: 18),
                          _IconBubble(icon: Icons.search_rounded),
                          const SizedBox(width: 10),
                          _OrderPill(),
                        ] else ...[
                          const SizedBox(width: 14),
                          _OrderPill(compact: true),
                          const SizedBox(width: 8),
                          _IconBubble(icon: Icons.menu_rounded, compact: true),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(
              delay: animationDelay,
              duration: animationDuration,
              curve: Curves.easeOutCubic,
            )
            .slideY(
              begin: -0.9,
              end: 0,
              delay: animationDelay,
              duration: animationDuration,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: AppColors.splashTextMuted,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, this.compact = false});

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: compact ? 38 : 42,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.14)),
      ),
      child: Icon(
        icon,
        color: AppColors.splashTextPrimary,
        size: compact ? 18 : 20,
      ),
    );
  }
}

class _OrderPill extends StatelessWidget {
  const _OrderPill({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.splashTextYellow,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.splashTextYellow.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        compact ? 'Order' : AppConstants.heroCta,
        style: AppTextStyles.button.copyWith(
          color: AppColors.splashDeepRed,
          fontSize: compact ? 13 : 14,
        ),
      ),
    );
  }
}
