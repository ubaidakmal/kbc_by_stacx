import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_spacing.dart';
import '../view_model/home_view_model.dart';
import 'hero_app_bar.dart';
import 'hero_background.dart';
import 'hero_dish_showcase.dart';
import 'hero_food_selector.dart';

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
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_heroIntroComplete, () {
      if (!mounted) return;
      context.read<HomeViewModel>().markHeroIntroCompleted();
    });
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

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
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
                          const HeroAppBar(
                            animationDelay: _appBarStart,
                            animationDuration: _appBarDuration,
                          ),
                          if (isMobile)
                            const _MobileHeroLayout()
                          else
                            const _DesktopHeroLayout(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DesktopHeroLayout extends StatelessWidget {
  const _DesktopHeroLayout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 54),
      child: Row(
        children: [
          Expanded(flex: 11, child: _HeroCopy(isCentered: false)),
          const HorizontalGap(28),
          const Expanded(flex: 10, child: _HeroVisuals(compact: false)),
        ],
      ),
    );
  }
}

class _MobileHeroLayout extends StatelessWidget {
  const _MobileHeroLayout();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 22, bottom: 34),
      child: Column(
        children: [
          _HeroCopy(isCentered: true),
          VerticalGap(28),
          _HeroVisuals(compact: true),
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
  const _HeroVisuals({required this.compact});

  final bool compact;

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
