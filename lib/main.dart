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
            if (splashViewModel.isLoading) {
              return const SplashScreen();
            }

            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
