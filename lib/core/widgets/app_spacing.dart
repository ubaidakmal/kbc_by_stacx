import 'package:flutter/widgets.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(dimension: size);
}

class VerticalGap extends StatelessWidget {
  const VerticalGap(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class HorizontalGap extends StatelessWidget {
  const HorizontalGap(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
