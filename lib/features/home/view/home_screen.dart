import 'package:flutter/material.dart';

import '../widgets/hero_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HeroSection());
  }
}
