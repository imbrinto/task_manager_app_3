import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_3/ui/screens/auth/set_password_screen.dart';
import 'package:task_manager_3/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/widgets/background_widget.dart';


class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();

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
                    'PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'A 6 digit verification pin will be sent to your email address',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  _buildPinCodeTextField(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _onTapNavSetPassScreen();
                    },
                    child: const Text('Verify'),
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

  void _onTapNavSetPassScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SetPasswordScreen(),
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

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      textStyle: const TextStyle(color: Colors.black),
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
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
    _pinTEController.dispose();
  }
}
