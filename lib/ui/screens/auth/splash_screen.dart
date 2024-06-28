import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_3/ui/controller/auth_controller.dart';
import 'package:task_manager_3/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_3/ui/screens/main_bottom_nav_bar.dart';
import 'package:task_manager_3/ui/utilities/app_assets.dart';
import 'package:task_manager_3/ui/widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    bool isUserSignedIn = await AuthController.checkAuthstate();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isUserSignedIn
              ? const MainBottomNavBar()
              : const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SvgPicture.asset(
            AssetPaths.appLogoSvg,
            width: 140,
          ),
        ),
      ),
    );
  }
}
