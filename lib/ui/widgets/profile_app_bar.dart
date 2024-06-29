import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/user_model.dart';
import 'package:task_manager_3/ui/controller/auth_controller.dart';
import 'package:task_manager_3/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_3/ui/screens/update_profile_screen.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/widgets/network_cached_image.dart';

AppBar profileAppBar(BuildContext context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        _onTapMoveToUpdateProfile(context);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: NetworkCachedImage(
            url: '',
          ),
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        if (fromUpdateProfile) {
          return;
        }
        _onTapMoveToUpdateProfile(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const Text(
            'email@gmail.com',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await AuthController.clearAllData();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false);
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.white70,
        ),
      ),
    ],
  );
}

void _onTapMoveToUpdateProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const UpdateProfileScreen(),
    ),
  );
}
