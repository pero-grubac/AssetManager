import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:asset_manager/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/theme_constants.dart';

class SplashScreen extends StatelessWidget {
  static const id = 'splash_screen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Center(
              child: Lottie.asset(
                'assets/animation/Animation - 1724342806817.json',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      nextScreen: const HomeScreen(),
      duration: 3000,
      backgroundColor: darkPrimaryColor,
      splashIconSize: double.infinity,
    );
  }
}
