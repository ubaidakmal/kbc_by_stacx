import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';

class VisitSection extends StatefulWidget {
  const VisitSection({required this.revealProgress, super.key});

  final double revealProgress;

  @override
  State<VisitSection> createState() => _VisitSectionState();
}

class _VisitSectionState extends State<VisitSection>
    with SingleTickerProviderStateMixin {
  static const double _sequenceStartThreshold = 0.2;
  static const double _sequenceResetThreshold = 0.03;

  late final AnimationController _sequenceController;

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSequenceWithScroll();
    });
  }

  @override
  void didUpdateWidget(covariant VisitSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSequenceWithScroll();
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    super.dispose();
  }

  void _syncSequenceWithScroll() {
    if (!mounted) return;

    if (widget.revealProgress >= _sequenceStartThreshold &&
        _sequenceController.status == AnimationStatus.dismissed) {
      _sequenceController.forward();
      return;
    }

    if (widget.revealProgress <= _sequenceResetThreshold &&
        _sequenceController.value > 0) {
      _sequenceController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 860;
        final progress = widget.revealProgress.clamp(0.0, 1.0);
        final sectionProgress = Curves.easeOutCubic.transform(progress);

        return Transform.translate(
          offset: Offset(0, (1 - sectionProgress) * 84),
          child: Opacity(
            opacity: sectionProgress,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 0 : 8,
                compact ? 50 : 82,
                compact ? 0 : 8,
                compact ? 92 : 130,
              ),
              child: AnimatedBuilder(
                animation: _sequenceController,
                builder: (context, child) {
                  return _VisitContent(
                    compact: compact,
                    sequenceProgress: _sequenceController.value,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VisitContent extends StatelessWidget {
  const _VisitContent({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimedReveal(
          progress: sequenceProgress,
          start: 0,
          end: 0.16,
          beginOffset: const Offset(0, 28),
          child: Text(
            AppConstants.visitEyebrow.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: AppColors.splashTextYellow,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
        ),
        const VerticalGap(16),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.18,
          end: 0.34,
          beginOffset: const Offset(0, 34),
          child: Text(
            AppConstants.visitHeadline,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.splashTextPrimary,
              fontSize: compact ? 36 : 56,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
        ),
        VerticalGap(compact ? 28 : 40),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.38,
          end: 0.58,
          beginOffset: const Offset(0, 30),
          child: _VisitInfoPanel(compact: compact),
        ),
        VerticalGap(compact ? 26 : 34),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.62,
          end: 0.78,
          beginOffset: const Offset(0, 22),
          child: _ContactButton(compact: compact),
        ),
      ],
    );
  }
}

class _VisitInfoPanel extends StatelessWidget {
  const _VisitInfoPanel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.splashTextPrimary.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.2),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 18 : 30,
              vertical: compact ? 20 : 28,
            ),
            child: compact
                ? const Column(
                    children: [
                      _VisitInfoItem(
                        icon: Icons.storefront_rounded,
                        label: AppConstants.visitRestaurantName,
                      ),
                      VerticalGap(14),
                      _VisitInfoItem(
                        icon: Icons.location_on_rounded,
                        label: AppConstants.visitAddress,
                      ),
                      VerticalGap(14),
                      _VisitInfoItem(
                        icon: Icons.phone_rounded,
                        label: AppConstants.visitPhone,
                      ),
                      VerticalGap(14),
                      _VisitInfoItem(
                        icon: Icons.access_time_filled_rounded,
                        label:
                            '${AppConstants.visitHoursLabel} ${AppConstants.visitHours}',
                      ),
                    ],
                  )
                : Column(
                    children: const [
                      Row(
                        children: [
                          Expanded(
                            child: _VisitInfoItem(
                              icon: Icons.storefront_rounded,
                              label: AppConstants.visitRestaurantName,
                            ),
                          ),
                          HorizontalGap(22),
                          Expanded(
                            child: _VisitInfoItem(
                              icon: Icons.location_on_rounded,
                              label: AppConstants.visitAddress,
                            ),
                          ),
                        ],
                      ),
                      VerticalGap(18),
                      Row(
                        children: [
                          Expanded(
                            child: _VisitInfoItem(
                              icon: Icons.phone_rounded,
                              label: AppConstants.visitPhone,
                            ),
                          ),
                          HorizontalGap(22),
                          Expanded(
                            child: _VisitInfoItem(
                              icon: Icons.access_time_filled_rounded,
                              label:
                                  '${AppConstants.visitHoursLabel} ${AppConstants.visitHours}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _VisitInfoItem extends StatelessWidget {
  const _VisitInfoItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.splashTextYellow.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.splashTextYellow.withValues(alpha: 0.18),
            ),
          ),
          child: Icon(icon, color: AppColors.splashTextYellow, size: 20),
        ),
        const HorizontalGap(12),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.splashTextMuted,
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.splashTextYellow,
              AppColors.splashTextOrange,
              AppColors.splashTextRed,
            ],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.splashTextYellow.withValues(alpha: 0.24),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 26 : 36,
            vertical: compact ? 14 : 16,
          ),
          child: Text(
            AppConstants.visitCta,
            style: AppTextStyles.button.copyWith(
              color: AppColors.splashTextPrimary,
              fontSize: compact ? 15 : 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimedReveal extends StatelessWidget {
  const _TimedReveal({
    required this.progress,
    required this.start,
    required this.end,
    required this.beginOffset,
    required this.child,
  });

  final double progress;
  final double start;
  final double end;
  final Offset beginOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final span = (end - start).clamp(0.001, 1.0);
    final rawProgress = ((progress - start) / span).clamp(0.0, 1.0);
    final easedProgress = Curves.easeOutCubic.transform(rawProgress);
    final offset = Offset(
      beginOffset.dx * (1 - easedProgress),
      beginOffset.dy * (1 - easedProgress),
    );

    return Transform.translate(
      offset: offset,
      child: Opacity(opacity: easedProgress, child: child),
    );
  }
}
