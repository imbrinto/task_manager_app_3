import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/login_model.dart';
import 'package:task_manager_3/data/models/network_response.dart';
import 'package:task_manager_3/data/network_caller/network_caller.dart';
import 'package:task_manager_3/data/utilities/urls.dart';
import 'package:task_manager_3/ui/controller/auth_controller.dart';
import 'package:task_manager_3/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager_3/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager_3/ui/screens/main_bottom_nav_bar.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/utilities/app_constants.dart';
import 'package:task_manager_3/ui/widgets/background_widget.dart';
import 'package:task_manager_3/ui/widgets/show_snackbar_message.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signInApiInProgress = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(hintText: 'Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email';
                        }
                        if (AppConstants.emailRegEx.hasMatch(value!) == false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: _passwordTEController,
                      obscureText: _showPassword == false,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              _showPassword = !_showPassword;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            )),
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _signInApiInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.themeColor),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _onTapNavBottomNavBar();
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 56),
                    _buildBackToSignInSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    _signInApiInProgress = true;
    if (mounted) {
      setState(() {});
    }

    dynamic requestData = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.login, body: requestData);
    _signInApiInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavBar()),
      );
    } else {
      showSnackbarMessage(
          context,
          response.errorMessage ??
              'Email/Password is not correct! Try again.');
    }
  }

  void _onTapNavBottomNavBar() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Widget _buildBackToSignInSection() {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              _onTapNavigateForgotPasswordPage();
            },
            child: const Text(
              'Forgot Password? ',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = _onTapNavigateSignUpPage,
                    text: "Sign Up",
                    style: const TextStyle(
                      color: AppColors.themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  void _onTapNavigateSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapNavigateForgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
