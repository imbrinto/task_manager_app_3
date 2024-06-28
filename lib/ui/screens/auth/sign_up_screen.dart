import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/network_response.dart';
import 'package:task_manager_3/data/network_caller/network_caller.dart';
import 'package:task_manager_3/data/utilities/urls.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/utilities/app_constants.dart';
import 'package:task_manager_3/ui/widgets/background_widget.dart';
import 'package:task_manager_3/ui/widgets/show_snackbar_message.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _registrationInProgress = false;


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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Join With Us',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: 'Email'),
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
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: 'First Name'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: 'Last Name'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      controller: _mobileTEController,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your mobile number';
                        }
                        // if(AppConstants.mobileNumberRegEx.hasMatch(value!) == false){
                        //   return 'Enter a valid mobile number';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: _showPassword == false,
                      controller: _passwordTEController,
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
                      visible: _registrationInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.themeColor,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _buildBackToSignInSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildBackToSignInSection() {
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



  void _registerUser() async {
    _registrationInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> registerInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.registration, body: registerInput);

    _registrationInProgress = false;
    if (mounted) {
      setState(() {});
    }
    
    if (response.isSuccess) {
      _clearTextFields();
      if (mounted) {
        showSnackbarMessage(context, 'Registration success', false);
      }
    } else {
      if (mounted) {
        showSnackbarMessage(context,
            response.errorMessage ?? 'Registration failed! Try again.', true);
      }
    }

  }

  void _clearTextFields() {
    _emailTEController.clear();
    _passwordTEController.clear();
    _mobileTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
  }

  void _onTapNavigateSignInPage() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
  }
}
