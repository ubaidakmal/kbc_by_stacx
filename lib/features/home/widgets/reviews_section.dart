import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_spacing.dart';
import '../view_model/home_view_model.dart';

class ReviewsSection extends StatefulWidget {
  const ReviewsSection({required this.revealProgress, super.key});

  final double revealProgress;

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection>
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
  void didUpdateWidget(covariant ReviewsSection oldWidget) {
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
        final compact = constraints.maxWidth < 760;
        final progress = widget.revealProgress.clamp(0.0, 1.0);
        final sectionProgress = Curves.easeOutCubic.transform(progress);

        return Transform.translate(
          offset: Offset(0, (1 - sectionProgress) * 82),
          child: Opacity(
            opacity: sectionProgress,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 0 : 8,
                compact ? 50 : 82,
                compact ? 0 : 8,
                compact ? 88 : 128,
              ),
              child: AnimatedBuilder(
                animation: _sequenceController,
                builder: (context, child) {
                  final sequenceProgress = _sequenceController.value;

                  return Column(
                    children: [
                      _ReviewsHeader(
                        compact: compact,
                        sequenceProgress: sequenceProgress,
                      ),
                      VerticalGap(compact ? 30 : 42),
                      _ReviewsCarousel(
                        compact: compact,
                        sequenceProgress: sequenceProgress,
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

class _ReviewsHeader extends StatelessWidget {
  const _ReviewsHeader({required this.compact, required this.sequenceProgress});

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
            AppConstants.reviewsEyebrow.toUpperCase(),
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
          start: 0.2,
          end: 0.36,
          beginOffset: const Offset(0, 34),
          child: Text(
            AppConstants.reviewsHeadline,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.splashTextPrimary,
              fontSize: compact ? 36 : 54,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
        ),
        const VerticalGap(18),
        _TimedReveal(
          progress: sequenceProgress,
          start: 0.4,
          end: 0.52,
          beginOffset: const Offset(0, 24),
          child: Text(
            AppConstants.reviewsDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.splashTextMuted,
              fontSize: compact ? 14 : 17,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewsCarousel extends StatefulWidget {
  const _ReviewsCarousel({
    required this.compact,
    required this.sequenceProgress,
  });

  final bool compact;
  final double sequenceProgress;

  @override
  State<_ReviewsCarousel> createState() => _ReviewsCarouselState();
}

class _ReviewsCarouselState extends State<_ReviewsCarousel> {
  int _startIndex = 0;
  int _direction = 1;

  void _move(int direction, int total) {
    if (total == 0) return;
    setState(() {
      _direction = direction;
      _startIndex = (_startIndex + direction + total) % total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviews = context.watch<HomeViewModel>().reviews;
    final visibleCount = widget.compact ? 1 : 3;
    final visibleReviews = List.generate(
      visibleCount,
      (index) => reviews[(_startIndex + index) % reviews.length],
    );

    return _TimedReveal(
      progress: widget.sequenceProgress,
      start: 0.56,
      end: 0.68,
      beginOffset: const Offset(0, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ReviewArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _move(-1, reviews.length),
              ),
              const SizedBox(width: 10),
              _ReviewArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _move(1, reviews.length),
              ),
            ],
          ),
          const VerticalGap(18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 520),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final offset = Tween<Offset>(
                begin: Offset(_direction * 0.12, 0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offset, child: child),
              );
            },
            child: Row(
              key: ValueKey('$_startIndex-$visibleCount'),
              children: List.generate(visibleReviews.length, (index) {
                final review = visibleReviews[index];
                final start = 0.7 + (index * 0.08);
                final end = start + 0.08;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == visibleReviews.length - 1 ? 0 : 20,
                    ),
                    child: _TimedReveal(
                      progress: widget.sequenceProgress,
                      start: start,
                      end: end,
                      beginOffset: const Offset(54, 0),
                      child: _ReviewCard(review: review),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewArrowButton extends StatelessWidget {
  const _ReviewArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.splashTextYellow.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.splashTextPrimary, size: 26),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  const _ReviewCard({required this.review});

  final ReviewItem review;

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.035 : 1,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 202),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _hovered
                  ? AppColors.splashTextYellow.withValues(alpha: 0.4)
                  : AppColors.splashTextPrimary.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(
                  alpha: _hovered ? 0.24 : 0.16,
                ),
                blurRadius: _hovered ? 34 : 24,
                offset: Offset(0, _hovered ? 18 : 12),
              ),
              BoxShadow(
                color: AppColors.splashTextYellow.withValues(
                  alpha: _hovered ? 0.18 : 0.06,
                ),
                blurRadius: _hovered ? 34 : 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '★★★★★',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.splashTextYellow,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const VerticalGap(22),
              Text(
                '"${widget.review.quote}"',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.splashDeepRed.withValues(alpha: 0.84),
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const VerticalGap(22),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.splashTextOrange,
                          AppColors.splashTextRed,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      widget.review.initial,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const HorizontalGap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.review.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.splashDeepRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'GOOGLE REVIEW',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primaryRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
