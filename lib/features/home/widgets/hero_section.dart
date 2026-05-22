import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_spacing.dart';
import '../view_model/home_view_model.dart';
import 'about_section.dart';
import 'catering_section.dart';
import 'hero_app_bar.dart';
import 'hero_background.dart';
import 'hero_dish_showcase.dart';
import 'hero_food_selector.dart';
import 'menu_section.dart';
import 'reviews_section.dart';
import 'why_customers_section.dart';

const _appBarStart = Duration.zero;
const _appBarDuration = Duration(milliseconds: 500);
const _headlineStart = Duration(milliseconds: 580);
const _headlineDuration = Duration(milliseconds: 550);
const _descriptionStart = Duration(milliseconds: 1210);
const _descriptionDuration = Duration(milliseconds: 450);
const _buttonStart = Duration(milliseconds: 1740);
const _buttonDuration = Duration(milliseconds: 400);
const _iconsStart = Duration(milliseconds: 2220);
const _iconDuration = Duration(milliseconds: 250);
const _iconGap = Duration(milliseconds: 330);
const _dishStart = Duration(milliseconds: 3210);
const _dishDuration = Duration(milliseconds: 600);
const _heroIntroComplete = Duration(milliseconds: 3900);

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  Timer? _introTimer;
  final _scrollController = ScrollController();
  final _rootKey = GlobalKey();
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _menuKey = GlobalKey();
  final _whyKey = GlobalKey();
  final _cateringKey = GlobalKey();
  final _reviewsKey = GlobalKey();
  final _heroDishKey = GlobalKey();
  final _aboutDishKey = GlobalKey();
  double _dishTravelProgress = 0;
  double _menuRevealProgress = 0;
  double _whyRevealProgress = 0;
  double _cateringRevealProgress = 0;
  double _reviewsRevealProgress = 0;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _introTimer = Timer(_heroIntroComplete, () {
      if (!mounted) return;
      context.read<HomeViewModel>().markHeroIntroCompleted();
    });
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _introTimer?.cancel();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final nextProgress = (_scrollController.offset / (viewportHeight * 0.72))
        .clamp(0.0, 1.0)
        .toDouble();
    final nextMenuProgress = _calculateMenuProgress(viewportHeight);
    final nextWhyProgress = _calculateWhyProgress(viewportHeight);
    final nextCateringProgress = _calculateCateringProgress(viewportHeight);
    final nextReviewsProgress = _calculateReviewsProgress(viewportHeight);
    final nextScrollOffset = _scrollController.offset;

    if ((nextProgress - _dishTravelProgress).abs() < 0.01 &&
        (nextMenuProgress - _menuRevealProgress).abs() < 0.01 &&
        (nextWhyProgress - _whyRevealProgress).abs() < 0.01 &&
        (nextCateringProgress - _cateringRevealProgress).abs() < 0.01 &&
        (nextReviewsProgress - _reviewsRevealProgress).abs() < 0.01 &&
        (nextScrollOffset - _lastScrollOffset).abs() < 0.5) {
      return;
    }

    setState(() {
      _dishTravelProgress = nextProgress;
      _menuRevealProgress = nextMenuProgress;
      _whyRevealProgress = nextWhyProgress;
      _cateringRevealProgress = nextCateringProgress;
      _reviewsRevealProgress = nextReviewsProgress;
      _lastScrollOffset = nextScrollOffset;
    });
  }

  double _calculateMenuProgress(double viewportHeight) {
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    final menuBox = _menuKey.currentContext?.findRenderObject() as RenderBox?;

    if (rootBox == null || menuBox == null) return _menuRevealProgress;

    final menuTop = menuBox.localToGlobal(Offset.zero, ancestor: rootBox).dy;
    return ((viewportHeight - menuTop) / (viewportHeight * 0.92))
        .clamp(0.0, 1.0)
        .toDouble();
  }

  double _calculateReviewsProgress(double viewportHeight) {
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    final reviewsBox =
        _reviewsKey.currentContext?.findRenderObject() as RenderBox?;

    if (rootBox == null || reviewsBox == null) return _reviewsRevealProgress;

    final reviewsTop = reviewsBox
        .localToGlobal(Offset.zero, ancestor: rootBox)
        .dy;
    return ((viewportHeight - reviewsTop) / (viewportHeight * 0.86))
        .clamp(0.0, 1.0)
        .toDouble();
  }

  double _calculateCateringProgress(double viewportHeight) {
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    final cateringBox =
        _cateringKey.currentContext?.findRenderObject() as RenderBox?;

    if (rootBox == null || cateringBox == null) return _cateringRevealProgress;

    final cateringTop = cateringBox
        .localToGlobal(Offset.zero, ancestor: rootBox)
        .dy;
    return ((viewportHeight - cateringTop) / (viewportHeight * 0.86))
        .clamp(0.0, 1.0)
        .toDouble();
  }

  double _calculateWhyProgress(double viewportHeight) {
    final rootBox = _rootKey.currentContext?.findRenderObject() as RenderBox?;
    final whyBox = _whyKey.currentContext?.findRenderObject() as RenderBox?;

    if (rootBox == null || whyBox == null) return _whyRevealProgress;

    final whyTop = whyBox.localToGlobal(Offset.zero, ancestor: rootBox).dy;
    return ((viewportHeight - whyTop) / (viewportHeight * 0.86))
        .clamp(0.0, 1.0)
        .toDouble();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToAbout() {
    final context = _aboutKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
      alignment: 0.06,
    );
  }

  void _scrollToMenu() {
    final context = _menuKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubic,
      alignment: 0.12,
    );
  }

  void _scrollToCatering() {
    final context = _cateringKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubic,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeroBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final isMobile = width < 820;
          final horizontalPadding = width < 420 ? 20.0 : 32.0;
          final contentWidth = (width - (horizontalPadding * 2)).clamp(
            0.0,
            AppConstants.maxHeroContentWidth,
          );

          return Stack(
            key: _rootKey,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: SafeArea(
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 0 : 8,
                          vertical: isMobile ? 4 : 10,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              key: _heroKey,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: height),
                                child: Column(
                                  children: [
                                    HeroAppBar(
                                      animationDelay: _appBarStart,
                                      animationDuration: _appBarDuration,
                                      onHomeTap: _scrollToTop,
                                      onAboutTap: _scrollToAbout,
                                      onMenuTap: _scrollToMenu,
                                      onCateringTap: _scrollToCatering,
                                    ),
                                    if (isMobile)
                                      _MobileHeroLayout(
                                        dishAnchorKey: _heroDishKey,
                                        dishTravelProgress: _dishTravelProgress,
                                      )
                                    else
                                      _DesktopHeroLayout(
                                        dishAnchorKey: _heroDishKey,
                                        dishTravelProgress: _dishTravelProgress,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            AboutSection(
                              key: _aboutKey,
                              dishTargetKey: _aboutDishKey,
                              revealProgress: _dishTravelProgress,
                              exitProgress: _menuRevealProgress,
                            ),
                            MenuSection(
                              key: _menuKey,
                              revealProgress: _menuRevealProgress,
                            ),
                            WhyCustomersSection(
                              key: _whyKey,
                              revealProgress: _whyRevealProgress,
                            ),
                            CateringSection(
                              key: _cateringKey,
                              revealProgress: _cateringRevealProgress,
                            ),
                            ReviewsSection(
                              key: _reviewsKey,
                              revealProgress: _reviewsRevealProgress,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _TravelingDishImage(
                rootKey: _rootKey,
                fromKey: _heroDishKey,
                toKey: _aboutDishKey,
                progress: _dishTravelProgress,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DesktopHeroLayout extends StatelessWidget {
  const _DesktopHeroLayout({
    required this.dishAnchorKey,
    required this.dishTravelProgress,
  });

  final GlobalKey dishAnchorKey;
  final double dishTravelProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 54),
      child: Row(
        children: [
          Expanded(flex: 11, child: _HeroCopy(isCentered: false)),
          const HorizontalGap(28),
          Expanded(
            flex: 10,
            child: _HeroVisuals(
              compact: false,
              dishAnchorKey: dishAnchorKey,
              dishTravelProgress: dishTravelProgress,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHeroLayout extends StatelessWidget {
  const _MobileHeroLayout({
    required this.dishAnchorKey,
    required this.dishTravelProgress,
  });

  final GlobalKey dishAnchorKey;
  final double dishTravelProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 34),
      child: Column(
        children: [
          const _HeroCopy(isCentered: true),
          const VerticalGap(28),
          _HeroVisuals(
            compact: true,
            dishAnchorKey: dishAnchorKey,
            dishTravelProgress: dishTravelProgress,
          ),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatefulWidget {
  const _HeroCopy({required this.isCentered});

  final bool isCentered;

  @override
  State<_HeroCopy> createState() => _HeroCopyState();
}

class _HeroCopyState extends State<_HeroCopy> {
  bool _isButtonPressed = false;
  bool _isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    final textAlign = widget.isCentered ? TextAlign.center : TextAlign.left;
    final crossAxisAlignment = widget.isCentered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        _HeroHeadline(textAlign: textAlign)
            .animate()
            .fadeIn(
              delay: _headlineStart,
              duration: _headlineDuration,
              curve: Curves.easeOutCubic,
            )
            .slideX(
              begin: -0.28,
              end: 0,
              delay: _headlineStart,
              duration: _headlineDuration,
              curve: Curves.easeOutCubic,
            ),
        const VerticalGap(20),
        Text(
              AppConstants.heroDescription,
              textAlign: textAlign,
              style: AppTextStyles.body.copyWith(
                color: AppColors.splashTextMuted,
                fontSize: widget.isCentered ? 15 : 16,
              ),
            )
            .animate()
            .fadeIn(
              delay: _descriptionStart,
              duration: _descriptionDuration,
              curve: Curves.easeOutCubic,
            )
            .slideX(
              begin: -0.22,
              end: 0,
              delay: _descriptionStart,
              duration: _descriptionDuration,
              curve: Curves.easeOutCubic,
            ),
        const VerticalGap(28),
        MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isButtonHovered = true),
              onExit: (_) => setState(() => _isButtonHovered = false),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isButtonPressed = true),
                onTapCancel: () => setState(() => _isButtonPressed = false),
                onTapUp: (_) => setState(() => _isButtonPressed = false),
                child: AnimatedScale(
                  scale: _isButtonPressed
                      ? 0.96
                      : (_isButtonHovered ? 1.04 : 1),
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  child: AppButton(
                    label: AppConstants.heroCta,
                    icon: Icons.local_fire_department_rounded,
                    onPressed: () {},
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(
              delay: _buttonStart,
              duration: _buttonDuration,
              curve: Curves.easeOutCubic,
            )
            .slideY(
              begin: 0.28,
              end: 0,
              delay: _buttonStart,
              duration: _buttonDuration,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline({required this.textAlign});

  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = (constraints.maxWidth * 0.1).clamp(38.0, 68.0);
        final baseStyle = AppTextStyles.headingLarge.copyWith(
          color: AppColors.splashTextPrimary,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 0.98,
        );

        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Karachi Street Food: ', style: baseStyle),
              TextSpan(
                text: 'Authentic Flavors',
                style: baseStyle.copyWith(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        AppColors.splashTextYellow,
                        AppColors.splashTextOrange,
                        AppColors.splashTextRed,
                      ],
                    ).createShader(const Rect.fromLTWH(0, 0, 430, 80)),
                ),
              ),
              TextSpan(text: ' of Karachi Biryani Center', style: baseStyle),
            ],
          ),
          textAlign: textAlign,
        );
      },
    );
  }
}

class _HeroVisuals extends StatelessWidget {
  const _HeroVisuals({
    required this.compact,
    required this.dishAnchorKey,
    required this.dishTravelProgress,
  });

  final bool compact;
  final GlobalKey dishAnchorKey;
  final double dishTravelProgress;

  @override
  Widget build(BuildContext context) {
    final introCompleted = context.select<HomeViewModel, bool>(
      (viewModel) => viewModel.heroIntroCompleted,
    );

    return SizedBox(
      width: compact ? 350 : 560,
      height: compact ? 430 : 560,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            right: 0,
            top: compact ? 58 : 18,
            child: HeroDishShowcase(
              compact: compact,
              dishAnchorKey: dishAnchorKey,
              travelProgress: dishTravelProgress,
              animationDelay: introCompleted ? Duration.zero : _dishStart,
              animationDuration: introCompleted
                  ? const Duration(milliseconds: 320)
                  : _dishDuration,
            ),
          ),
          Positioned(
            left: compact ? 0 : 8,
            top: compact ? 12 : 0,
            child: HeroFoodSelector(
              compact: compact,
              animationStart: introCompleted ? Duration.zero : _iconsStart,
              iconDuration: introCompleted
                  ? const Duration(milliseconds: 220)
                  : _iconDuration,
              iconGap: introCompleted ? Duration.zero : _iconGap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TravelingDishImage extends StatelessWidget {
  const _TravelingDishImage({
    required this.rootKey,
    required this.fromKey,
    required this.toKey,
    required this.progress,
  });

  final GlobalKey rootKey;
  final GlobalKey fromKey;
  final GlobalKey toKey;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final rootBox = rootKey.currentContext?.findRenderObject() as RenderBox?;
    final fromBox = fromKey.currentContext?.findRenderObject() as RenderBox?;
    final toBox = toKey.currentContext?.findRenderObject() as RenderBox?;

    if (rootBox == null || fromBox == null || toBox == null || progress <= 0) {
      return const SizedBox.shrink();
    }

    final fromOffset = fromBox.localToGlobal(Offset.zero, ancestor: rootBox);
    final toOffset = toBox.localToGlobal(Offset.zero, ancestor: rootBox);
    final fromRect = fromOffset & fromBox.size;
    final toRect = toOffset & toBox.size;
    final easedProgress = Curves.easeInOutCubic.transform(progress);
    final rect = Rect.lerp(fromRect, toRect, easedProgress)!;
    final selectedDish = context.watch<HomeViewModel>().selectedDish;

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: IgnorePointer(
        child: ClipOval(
          child: Image.asset(selectedDish.dishImage, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
