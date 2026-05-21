import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/view/home_screen.dart';
import 'features/home/view_model/home_view_model.dart';
import 'features/splash/view/splash_screen.dart';
import 'features/splash/view_model/splash_view_model.dart';

void main() {
  runApp(const BiryaniHouseApp());
}

class BiryaniHouseApp extends StatelessWidget {
  const BiryaniHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()..startSplash()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: AppConstants.brandName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<SplashViewModel>(
          builder: (context, splashViewModel, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 650),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: splashViewModel.isLoading
                  ? const SplashScreen(key: ValueKey('splash-screen'))
                  : const HomeScreen(key: ValueKey('home-screen')),
            );
          },
        ),
      ),
    );
  }
}
