import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class PillButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const PillButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: AppColors.white.withOpacity(0.5),
          width: AppSizes.dividerThickness,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: AppSizes.iconSizeSmall),
          SizedBox(width: AppSizes.paddingSmall),
          Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.paddingMedium,
            ),
          ),
        ],
      ),
    );
  }
}
