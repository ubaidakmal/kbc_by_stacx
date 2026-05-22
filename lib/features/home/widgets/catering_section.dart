import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';
import '../view_model/home_view_model.dart';

class CateringSection extends StatefulWidget {
  const CateringSection({required this.revealProgress, super.key});

  final double revealProgress;

  @override
  State<CateringSection> createState() => _CateringSectionState();
}

class _CateringSectionState extends State<CateringSection>
    with SingleTickerProviderStateMixin {
  static const double _sequenceStartThreshold = 0.2;
  static const double _sequenceResetThreshold = 0.03;

  late final AnimationController _sequenceController;

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSequenceWithScroll();
    });
  }

  @override
  void didUpdateWidget(covariant CateringSection oldWidget) {
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
          offset: Offset(0, (1 - sectionProgress) * 86),
          child: Opacity(
            opacity: sectionProgress,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 0 : 8,
                compact ? 50 : 82,
                compact ? 0 : 8,
                compact ? 90 : 128,
              ),
              child: AnimatedBuilder(
                animation: _sequenceController,
                builder: (context, child) {
                  return _CateringPanel(
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

class _CateringPanel extends StatelessWidget {
  const _CateringPanel({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 28 : 36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 28 : 36),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.splashMaroon.withValues(alpha: 0.82),
                AppColors.fireRed.withValues(alpha: 0.62),
                AppColors.fireOrange.withValues(alpha: 0.9),
              ],
            ),
            border: Border.all(
              color: AppColors.splashTextYellow.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.splashWarmOrangeGlow.withValues(alpha: 0.14),
                blurRadius: 70,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.28),
                blurRadius: 46,
                offset: const Offset(0, 28),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: _CateringPanelAtmosphere()),
              Padding(
                padding: EdgeInsets.all(compact ? 28 : 64),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CateringCopy(
                            compact: compact,
                            sequenceProgress: sequenceProgress,
                          ),
                          const VerticalGap(34),
                          _CateringStats(
                            compact: compact,
                            sequenceProgress: sequenceProgress,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 11,
                            child: _CateringCopy(
                              compact: compact,
                              sequenceProgress: sequenceProgress,
                            ),
                          ),
                          const HorizontalGap(54),
                          Expanded(
                            flex: 8,
                            child: _CateringStats(
                              compact: compact,
                              sequenceProgress: sequenceProgress,
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

class _CateringPanelAtmosphere extends StatelessWidget {
  const _CateringPanelAtmosphere();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CateringAtmospherePainter());
  }
}

class _CateringAtmospherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final warmGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.85, -0.1),
        radius: 0.8,
        colors: [
          AppColors.splashYellowGlow.withValues(alpha: 0.18),
          AppColors.splashWarmOrangeGlow.withValues(alpha: 0.08),
          AppColors.splashDeepRed.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, warmGlow);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.splashTextYellow.withValues(alpha: 0.09);

    final arc = Path()
      ..moveTo(size.width * 0.02, size.height * 0.22)
      ..quadraticBezierTo(
        size.width * 0.48,
        -size.height * 0.12,
        size.width * 0.98,
        size.height * 0.2,
      );
    canvas.drawPath(arc, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CateringCopy extends StatelessWidget {
  const _CateringCopy({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        _TimedReveal(
          progress: sequenceProgress,
          start: 0,
          end: 0.18,
          beginOffset: const Offset(0, 26),
          child: Text(
            AppConstants.cateringEyebrow.toUpperCase(),
            textAlign: compact ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.label.copyWith(
              color: AppColors.splashTextYellow,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
        ),
        const VerticalGap(22),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.21,
          end: 0.38,
          beginOffset: const Offset(0, 34),
          child: Text(
            AppConstants.cateringHeadline,
            textAlign: compact ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.splashTextPrimary,
              fontSize: compact ? 40 : 62,
              fontWeight: FontWeight.w900,
              height: 1.18,
            ),
          ),
        ),
        const VerticalGap(28),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.42,
          end: 0.56,
          beginOffset: const Offset(0, 26),
          child: Text(
            AppConstants.cateringDescription,
            textAlign: compact ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.body.copyWith(
              color: AppColors.splashTextPrimary.withValues(alpha: 0.82),
              fontSize: compact ? 15 : 18,
              height: 1.55,
            ),
          ),
        ),
        const VerticalGap(34),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.6,
          end: 0.72,
          beginOffset: const Offset(0, 22),
          child: Align(
            alignment: compact ? Alignment.center : Alignment.centerLeft,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 15,
                ),
                child: Text(
                  AppConstants.cateringCta.toUpperCase(),
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.splashTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CateringStats extends StatelessWidget {
  const _CateringStats({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    final metrics = context.watch<HomeViewModel>().cateringMetrics;

    return _TimedReveal(
      progress: sequenceProgress,
      start: 0.74,
      end: 0.88,
      beginOffset: Offset(compact ? 0 : 44, compact ? 28 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.splashDeepRed.withValues(alpha: 0.46),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.splashTextPrimary.withValues(alpha: 0.08),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(compact ? 18 : 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: metrics.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: compact ? 2 : 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: compact ? 1.45 : 1.9,
                ),
                itemBuilder: (context, index) {
                  final metric = metrics[index];
                  final start = 0.8 + (index * 0.045);
                  final end = math.min(start + 0.12, 0.99);

                  return _MetricTile(
                    metric: metric,
                    progress: sequenceProgress,
                    start: start,
                    end: end,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.metric,
    required this.progress,
    required this.start,
    required this.end,
  });

  final CateringMetric metric;
  final double progress;
  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    return _TimedReveal(
      progress: progress,
      start: start,
      end: end,
      beginOffset: const Offset(26, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.11),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.splashTextPrimary.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: AlwaysStoppedAnimation(progress),
            builder: (context, child) {
              final valueProgress = ((progress - start) / (end - start)).clamp(
                0.0,
                1.0,
              );
              final easedValue = Curves.easeOutCubic.transform(valueProgress);
              final displayValue = (metric.value * easedValue).round();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    metric.isTextMetric
                        ? metric.suffix
                        : '$displayValue${metric.suffix}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.splashTextYellow,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const VerticalGap(8),
                  Text(
                    metric.label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.splashTextPrimary.withValues(
                        alpha: 0.72,
                      ),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.6,
                    ),
                  ),
                ],
              );
            },
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
