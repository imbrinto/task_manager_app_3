import 'package:flutter/material.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';

class CenteredProgressIndicator extends StatelessWidget {
  const CenteredProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.themeColor,
      ),
    );
  }
}
