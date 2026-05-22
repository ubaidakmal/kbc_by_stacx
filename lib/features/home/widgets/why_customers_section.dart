import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';
import '../view_model/home_view_model.dart';

class WhyCustomersSection extends StatefulWidget {
  const WhyCustomersSection({required this.revealProgress, super.key});

  final double revealProgress;

  @override
  State<WhyCustomersSection> createState() => _WhyCustomersSectionState();
}

class _WhyCustomersSectionState extends State<WhyCustomersSection>
    with SingleTickerProviderStateMixin {
  static const double _sequenceStartThreshold = 0.2;
  static const double _sequenceResetThreshold = 0.03;

  late final AnimationController _sequenceController;

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSequenceWithScroll();
    });
  }

  @override
  void didUpdateWidget(covariant WhyCustomersSection oldWidget) {
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
        final compact = constraints.maxWidth < 820;
        final progress = widget.revealProgress.clamp(0.0, 1.0);
        final sectionProgress = Curves.easeOutCubic.transform(progress);

        return Transform.translate(
          offset: Offset(0, (1 - sectionProgress) * 92),
          child: Opacity(
            opacity: sectionProgress,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 0 : 8,
                compact ? 56 : 88,
                compact ? 0 : 8,
                compact ? 82 : 124,
              ),
              child: Stack(
                children: [
                  const Positioned.fill(child: _WhyAtmosphere()),
                  AnimatedBuilder(
                    animation: _sequenceController,
                    builder: (context, child) {
                      final sequenceProgress = _sequenceController.value;

                      return Column(
                        children: [
                          _WhyHeader(
                            compact: compact,
                            sequenceProgress: sequenceProgress,
                          ),
                          VerticalGap(compact ? 30 : 42),
                          _WhyStepsGrid(
                            compact: compact,
                            sequenceProgress: sequenceProgress,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WhyAtmosphere extends StatelessWidget {
  const _WhyAtmosphere();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _WhyAtmospherePainter()));
  }
}

class _WhyAtmospherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final warmGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.splashWarmOrangeGlow.withValues(alpha: 0.12),
              AppColors.splashFireGlow.withValues(alpha: 0.05),
              AppColors.splashDeepRed.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.4),
              radius: size.shortestSide * 0.7,
            ),
          );

    canvas.drawRect(Offset.zero & size, warmGlow);

    final linePaint = Paint()
      ..color = AppColors.splashTextYellow.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final topArc = Path()
      ..moveTo(size.width * 0.08, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.5,
        -size.height * 0.08,
        size.width * 0.92,
        size.height * 0.2,
      );
    canvas.drawPath(topArc, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WhyHeader extends StatelessWidget {
  const _WhyHeader({required this.compact, required this.sequenceProgress});

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
            AppConstants.whyEyebrow.toUpperCase(),
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
          start: 0.19,
          end: 0.34,
          beginOffset: const Offset(0, 34),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Text(
              AppConstants.whyHeadline,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingLarge.copyWith(
                color: AppColors.splashTextPrimary,
                fontSize: compact ? 36 : 58,
                fontWeight: FontWeight.w900,
                height: 1.08,
              ),
            ),
          ),
        ),
        const VerticalGap(20),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.38,
          end: 0.5,
          beginOffset: const Offset(0, 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 690),
            child: Text(
              AppConstants.whyDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.splashTextMuted,
                fontSize: compact ? 14 : 17,
                height: 1.55,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WhyStepsGrid extends StatelessWidget {
  const _WhyStepsGrid({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    final steps = context.watch<HomeViewModel>().whySteps;
    final maxCardWidth = compact ? 420.0 : 390.0;
    final childAspectRatio = compact ? 2.0 : 2.08;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCardWidth,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final step = steps[index];
        final start = 0.56 + (index * 0.07);
        final end = start + 0.058;

        return _TimedReveal(
          progress: sequenceProgress,
          start: start,
          end: end,
          beginOffset: const Offset(-72, 0),
          child: _WhyStepCard(step: step, index: index),
        );
      },
    );
  }
}

class _WhyStepCard extends StatelessWidget {
  const _WhyStepCard({required this.step, required this.index});

  final WhyStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    final number = (index + 1).toString().padLeft(2, '0');

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white.withValues(alpha: 0.13),
                AppColors.splashMaroon.withValues(alpha: 0.5),
                AppColors.splashDeepRed.withValues(alpha: 0.76),
              ],
            ),
            border: Border.all(
              color: AppColors.splashTextYellow.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                top: -30,
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.splashYellowGlow.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.splashTextYellow,
                            AppColors.splashTextOrange,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.splashTextYellow.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        number,
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.splashDeepRed,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const HorizontalGap(18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            step.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.splashTextPrimary,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const VerticalGap(8),
                          Text(
                            step.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.splashTextMuted,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
