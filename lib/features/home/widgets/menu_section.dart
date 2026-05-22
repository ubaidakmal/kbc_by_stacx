import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_spacing.dart';
import '../view_model/home_view_model.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({required this.revealProgress, super.key});

  final double revealProgress;

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection>
    with SingleTickerProviderStateMixin {
  static const double _sequenceStartThreshold = 0.24;
  static const double _sequenceResetThreshold = 0.03;

  late final AnimationController _sequenceController;

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSequenceWithScroll();
    });
  }

  @override
  void didUpdateWidget(covariant MenuSection oldWidget) {
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
          offset: Offset(0, (1 - sectionProgress) * 96),
          child: Opacity(
            opacity: sectionProgress.clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 0 : 8,
                compact ? 50 : 82,
                compact ? 0 : 8,
                compact ? 76 : 112,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackOverlay.withValues(alpha: 0.26),
                      blurRadius: 48,
                      offset: const Offset(0, 28),
                    ),
                    BoxShadow(
                      color: AppColors.splashYellowGlow.withValues(alpha: 0.08),
                      blurRadius: 80,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      const Positioned.fill(child: _MenuPanelAtmosphere()),
                      AnimatedBuilder(
                        animation: _sequenceController,
                        builder: (context, child) {
                          final sequenceProgress = _sequenceController.value;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 18 : 34,
                              vertical: compact ? 28 : 42,
                            ),
                            child: Column(
                              children: [
                                _MenuHeader(
                                  compact: compact,
                                  sequenceProgress: sequenceProgress,
                                ),
                                VerticalGap(compact ? 22 : 28),
                                _MenuTabs(sequenceProgress: sequenceProgress),
                                VerticalGap(compact ? 24 : 34),
                                _MenuProductGrid(
                                  compact: compact,
                                  sequenceProgress: sequenceProgress,
                                ),
                                const VerticalGap(28),
                                _SequenceTransition(
                                  progress: sequenceProgress,
                                  start: 0.96,
                                  end: 1,
                                  beginOffset: const Offset(0, 20),
                                  child: AppButton(
                                    label: 'Explore More',
                                    icon: Icons.arrow_forward_rounded,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuPanelAtmosphere extends StatelessWidget {
  const _MenuPanelAtmosphere();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MenuPanelPainter());
  }
}

class _MenuPanelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.splashWarmOrangeGlow.withValues(alpha: 0.18),
              AppColors.splashFireGlow.withValues(alpha: 0.08),
              AppColors.splashDeepRed.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.28),
              radius: size.shortestSide * 0.65,
            ),
          );
    canvas.drawRect(Offset.zero & size, centerGlow);

    final yellowGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.splashYellowGlow.withValues(alpha: 0.14),
              AppColors.splashYellowGlow.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.84, size.height * 0.18),
              radius: size.shortestSide * 0.34,
            ),
          );
    canvas.drawRect(Offset.zero & size, yellowGlow);

    final pathPaint = Paint()
      ..color = AppColors.splashTextYellow.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.32)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.04,
        size.width * 0.94,
        size.height * 0.3,
      );
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.compact, required this.sequenceProgress});

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SequenceTransition(
          progress: sequenceProgress,
          start: 0,
          end: 0.22,
          beginOffset: const Offset(0, 34),
          child: Column(
            children: [
              Text(
                AppConstants.menuEyebrow,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.splashTextYellow,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const VerticalGap(8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Our ',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.splashTextPrimary,
                        fontSize: compact ? 34 : 48,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                      ),
                    ),
                    TextSpan(
                      text: 'Popular',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: compact ? 34 : 48,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              AppColors.splashTextYellow,
                              AppColors.splashTextOrange,
                              AppColors.splashTextRed,
                            ],
                          ).createShader(const Rect.fromLTWH(0, 0, 240, 70)),
                      ),
                    ),
                    TextSpan(
                      text: ' Menu',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.splashTextPrimary,
                        fontSize: compact ? 34 : 48,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const VerticalGap(12),
        _SequenceTransition(
          progress: sequenceProgress,
          start: 0.25,
          end: 0.43,
          beginOffset: const Offset(0, 26),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              AppConstants.menuDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.splashTextMuted,
                fontSize: compact ? 14 : 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuTabs extends StatelessWidget {
  const _MenuTabs({required this.sequenceProgress});

  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return _SequenceTransition(
      progress: sequenceProgress,
      start: 0.46,
      end: 0.62,
      beginOffset: const Offset(-92, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.12),
                AppColors.white.withValues(alpha: 0.045),
                AppColors.splashWarmOrangeGlow.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(viewModel.menuCategories.length, (index) {
                final category = viewModel.menuCategories[index];
                final active = index == viewModel.selectedMenuCategoryIndex;
                return _MenuTabButton(
                  label: category.title,
                  active: active,
                  onTap: () => viewModel.selectMenuCategory(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuTabButton extends StatelessWidget {
  const _MenuTabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: active ? null : AppColors.white.withValues(alpha: 0.04),
            gradient: active
                ? const LinearGradient(
                    colors: [
                      AppColors.splashTextYellow,
                      AppColors.splashTextOrange,
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? AppColors.splashTextPrimary.withValues(alpha: 0.34)
                  : AppColors.white.withValues(alpha: 0.08),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.splashTextYellow.withValues(alpha: 0.28),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: active
                  ? AppColors.splashDeepRed
                  : AppColors.splashTextMuted,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuProductGrid extends StatelessWidget {
  const _MenuProductGrid({
    required this.compact,
    required this.sequenceProgress,
  });

  final bool compact;
  final double sequenceProgress;

  @override
  Widget build(BuildContext context) {
    final category = context.watch<HomeViewModel>().selectedMenuCategory;
    final maxCrossAxisExtent = compact ? 420.0 : 270.0;
    final childAspectRatio = compact ? 0.74 : 0.75;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Column(
        key: ValueKey(category.title),
        children: [
          _SequenceTransition(
            progress: sequenceProgress,
            start: 0.63,
            end: 0.69,
            beginOffset: const Offset(0, 18),
            child: _MenuCategoryIntro(category: category, compact: compact),
          ),
          const VerticalGap(34),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: category.items.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final item = category.items[index];
              final start = 0.66 + (index * 0.065);
              final end = math.min(start + 0.1, 0.99);

              return _ProductCardTransition(
                progress: sequenceProgress,
                start: start,
                end: end,
                child: _MenuProductCard(item: item),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuCategoryIntro extends StatelessWidget {
  const _MenuCategoryIntro({required this.category, required this.compact});

  final MenuCategory category;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        children: [
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.splashTextPrimary,
              fontSize: compact ? 22 : 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const VerticalGap(8),
          Text(
            category.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.splashTextMuted,
              fontSize: compact ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuProductCard extends StatelessWidget {
  const _MenuProductCard({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = math.min(
          168.0,
          math.min(constraints.maxWidth * 0.74, constraints.maxHeight * 0.34),
        );
        final imageTop = 0.0;
        final cardTop = imageSize * 0.42;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              top: cardTop,
              child: _MenuCardShell(
                topPadding: (imageSize * 0.58) + 18,
                item: item,
              ),
            ),
            Positioned(
              top: imageTop,
              child: _FloatingDishImage(
                image: item.image,
                label: item.title,
                size: imageSize,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuCardShell extends StatelessWidget {
  const _MenuCardShell({required this.topPadding, required this.item});

  final double topPadding;
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, 0.42, 1],
              colors: [
                AppColors.white.withValues(alpha: 0.18),
                AppColors.splashMaroon.withValues(alpha: 0.52),
                AppColors.splashDeepRed.withValues(alpha: 0.7),
              ],
            ),
            border: Border.all(
              color: AppColors.splashTextPrimary.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay.withValues(alpha: 0.24),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: AppColors.splashWarmOrangeGlow.withValues(alpha: 0.08),
                blurRadius: 42,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.white.withValues(alpha: 0.14),
                        AppColors.white.withValues(alpha: 0.03),
                        AppColors.blackOverlay.withValues(alpha: 0.12),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 10,
                width: 74,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, topPadding, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.splashTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                      ),
                    ),
                    const VerticalGap(9),
                    Expanded(
                      child: Text(
                        item.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.splashTextMuted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const VerticalGap(12),
                    Row(
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.splashTextYellow,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.splashTextYellow.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 10,
                              ),
                              child: Text(
                                'Order Now',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.splashDeepRed,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '\$${item.price}',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.splashTextYellow,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ],
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

class _FloatingDishImage extends StatelessWidget {
  const _FloatingDishImage({
    required this.image,
    required this.label,
    required this.size,
  });

  final String image;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageScale = switch (image) {
      AppImages.biryaniImage3 || AppImages.biryaniImage4 => 1.34,
      AppImages.biryaniImage1 ||
      AppImages.biryaniImage2 ||
      AppImages.biryaniImage5 => 0.9,
      _ => 1.0,
    };

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * 0.94,
          height: size * 0.94,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.splashYellowGlow.withValues(alpha: 0.26),
                AppColors.splashWarmOrangeGlow.withValues(alpha: 0.12),
                AppColors.splashDeepRed.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        Transform.scale(
          scale: imageScale,
          child: Image.asset(
            image,
            width: size,
            height: size,
            fit: BoxFit.contain,
            semanticLabel: label,
          ),
        ),
      ],
    );
  }
}

class _ProductCardTransition extends StatelessWidget {
  const _ProductCardTransition({
    required this.progress,
    required this.start,
    required this.end,
    required this.child,
  });

  final double progress;
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final span = (end - start).clamp(0.001, 1.0);
    final rawProgress = ((progress - start) / span).clamp(0.0, 1.0);
    final easedProgress = Curves.easeOutQuart.transform(rawProgress);
    final slide = 92 * (1 - easedProgress);
    final scale = 0.96 + (0.04 * easedProgress);

    return Transform.translate(
      offset: Offset(slide, 0),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: Opacity(opacity: easedProgress, child: child),
      ),
    );
  }
}

class _SequenceTransition extends StatelessWidget {
  const _SequenceTransition({
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
