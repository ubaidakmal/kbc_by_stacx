import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';

class SocialCtaSection extends StatefulWidget {
  const SocialCtaSection({required this.revealProgress, super.key});

  final double revealProgress;

  @override
  State<SocialCtaSection> createState() => _SocialCtaSectionState();
}

class _SocialCtaSectionState extends State<SocialCtaSection>
    with SingleTickerProviderStateMixin {
  static const double _sequenceStartThreshold = 0.52;
  static const double _sequenceResetThreshold = 0.12;

  late final AnimationController _sequenceController;

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSequenceWithScroll();
    });
  }

  @override
  void didUpdateWidget(covariant SocialCtaSection oldWidget) {
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
                compact ? 66 : 94,
              ),
              child: AnimatedBuilder(
                animation: _sequenceController,
                builder: (context, child) {
                  final sequenceProgress = _sequenceController.value;

                  return Column(
                    children: [
                      _TimedReveal(
                        progress: sequenceProgress,
                        start: 0,
                        end: 0.18,
                        beginOffset: const Offset(0, 34),
                        child: _SocialPanel(
                          compact: compact,
                          sequenceProgress: sequenceProgress,
                        ),
                      ),
                      VerticalGap(compact ? 44 : 72),
                      _TimedReveal(
                        progress: sequenceProgress,
                        start: 0.62,
                        end: 0.78,
                        beginOffset: const Offset(0, 38),
                        child: _HungryPanel(
                          compact: compact,
                          sequenceProgress: sequenceProgress,
                        ),
                      ),
                    ],
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

class _SocialPanel extends StatelessWidget {
  const _SocialPanel({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.055),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.splashTextYellow.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.24),
                blurRadius: 36,
                offset: const Offset(0, 22),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 24 : 34),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _SocialCopy(
                        compact: compact,
                        sequenceProgress: sequenceProgress,
                      ),
                      const VerticalGap(28),
                      _InstagramGrid(
                        compact: compact,
                        sequenceProgress: sequenceProgress,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: _SocialCopy(
                          compact: compact,
                          sequenceProgress: sequenceProgress,
                        ),
                      ),
                      const HorizontalGap(44),
                      Expanded(
                        flex: 9,
                        child: _InstagramGrid(
                          compact: compact,
                          sequenceProgress: sequenceProgress,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SocialCopy extends StatelessWidget {
  const _SocialCopy({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    final alignment = compact ? TextAlign.center : TextAlign.left;

    return Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.08,
          end: 0.22,
          beginOffset: const Offset(0, 24),
          child: Text(
            AppConstants.socialEyebrow.toUpperCase(),
            textAlign: alignment,
            style: AppTextStyles.label.copyWith(
              color: AppColors.splashTextYellow,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
        ),
        const VerticalGap(14),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.24,
          end: 0.4,
          beginOffset: const Offset(0, 30),
          child: Text(
            AppConstants.socialHeadline,
            textAlign: alignment,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.splashTextPrimary,
              fontSize: compact ? 34 : 40,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
        ),
        const VerticalGap(26),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.42,
          end: 0.54,
          beginOffset: const Offset(0, 22),
          child: _SmallGradientButton(label: AppConstants.socialCta),
        ),
      ],
    );
  }
}

class _InstagramGrid extends StatelessWidget {
  const _InstagramGrid({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  static const _items = [
    AppImages.biryaniImage1,
    AppImages.biryaniImage2,
    AppImages.biryaniImage3,
    AppImages.biryaniImage4,
    AppImages.biryaniImage5,
    AppImages.biryaniImage1,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: compact ? 2 : 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final start = 0.24 + (index * 0.055);
        final end = start + 0.12;

        return _TimedReveal(
          progress: sequenceProgress,
          start: start,
          end: end,
          beginOffset: Offset(index.isEven ? 36 : -36, 24),
          child: _InstagramTile(image: _items[index], index: index),
        );
      },
    );
  }
}

class _InstagramTile extends StatefulWidget {
  const _InstagramTile({required this.image, required this.index});

  final String image;
  final int index;

  @override
  State<_InstagramTile> createState() => _InstagramTileState();
}

class _InstagramTileState extends State<_InstagramTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.splashMaroon.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.splashTextPrimary.withValues(alpha: 0.1),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.splashWarmOrangeGlow.withValues(alpha: 0.16),
                        AppColors.splashDeepRed.withValues(alpha: 0.86),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.contain,
                    semanticLabel: 'Karachi biryani social post',
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blackOverlay.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        '#${widget.index + 1}',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.splashTextPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HungryPanel extends StatelessWidget {
  const _HungryPanel({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.splashTextYellow,
              AppColors.splashTextOrange,
              AppColors.fireRed,
              AppColors.primaryRed,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.splashWarmOrangeGlow.withValues(alpha: 0.28),
              blurRadius: 72,
              offset: const Offset(0, 28),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _HungryOverlay()),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 24 : 54,
                vertical: compact ? 34 : 48,
              ),
              child: Column(
                children: [
                  _TimedReveal(
                    progress: sequenceProgress,
                    start: 0.72,
                    end: 0.82,
                    beginOffset: const Offset(0, 18),
                    child: Text(
                      AppConstants.hungryEyebrow.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.splashDeepRed.withValues(alpha: 0.86),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  const VerticalGap(16),
                  _TimedReveal(
                    progress: sequenceProgress,
                    start: 0.82,
                    end: 0.9,
                    beginOffset: const Offset(0, 24),
                    child: Text(
                      AppConstants.hungryHeadline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.splashDeepRed,
                        fontSize: compact ? 42 : 64,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                      ),
                    ),
                  ),
                  const VerticalGap(16),
                  _TimedReveal(
                    progress: sequenceProgress,
                    start: 0.9,
                    end: 0.96,
                    beginOffset: const Offset(0, 18),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Text(
                        AppConstants.hungryDescription,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.splashDeepRed.withValues(
                            alpha: 0.82,
                          ),
                          fontSize: compact ? 14 : 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const VerticalGap(28),
                  _TimedReveal(
                    progress: sequenceProgress,
                    start: 0.96,
                    end: 1,
                    beginOffset: const Offset(0, 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _HungryButton(label: AppConstants.hungryOrderCta),
                        _HungryButton(label: AppConstants.hungryCallCta),
                        _HungryButton(label: AppConstants.hungryDmCta),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HungryOverlay extends StatelessWidget {
  const _HungryOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _HungryOverlayPainter());
  }
}

class _HungryOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final vignette = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.white.withValues(alpha: 0.18),
              AppColors.white.withValues(alpha: 0),
              AppColors.splashDeepRed.withValues(alpha: 0.22),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.2),
              radius: size.shortestSide * 0.9,
            ),
          );
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmallGradientButton extends StatelessWidget {
  const _SmallGradientButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
            color: AppColors.splashTextYellow.withValues(alpha: 0.2),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.button.copyWith(
            color: AppColors.splashTextPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _HungryButton extends StatelessWidget {
  const _HungryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isPrimary = label == AppConstants.hungryOrderCta;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.splashDeepRed
            : AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isPrimary
              ? AppColors.splashDeepRed.withValues(alpha: 0.18)
              : AppColors.splashTextPrimary.withValues(alpha: 0.26),
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.splashDeepRed.withValues(alpha: 0.2),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.button.copyWith(
            color: isPrimary
                ? AppColors.splashTextPrimary
                : AppColors.splashDeepRed,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
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
