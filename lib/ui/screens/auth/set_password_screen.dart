import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_3/ui/screens/auth/otp_verification_screen.dart';
import 'package:task_manager_3/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/widgets/background_widget.dart';


class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() =>
      _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Maximum length of password should not be less then 8 character with letter an number combination',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(hintText: 'Confirm Password'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // _onTapNavigateOTPScreen();
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                  const SizedBox(height: 56),
                  _buildBackToSignInSection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _buildBackToSignInSection() {
    return Center(
      child: RichText(
          text: TextSpan(
        children: [
          const TextSpan(
            text: "Have account? ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = _onTapNavigateSignInPage,
            text: "Sign In",
            style: const TextStyle(
              color: AppColors.themeColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      )),
    );
  }

  void _onTapNavigateOTPScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OTPVerificationScreen(),
      ),
    );
  }

  void _onTapNavigateSignInPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
