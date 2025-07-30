import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class ExpertTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const ExpertTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmall + 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
          border: isSelected ? Border.all(color: AppColors.primaryGreen) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.black87,
              size: AppSizes.iconSizeMedium,
            ),
            SizedBox(width: AppSizes.paddingSmall),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGreen : AppColors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: AppSizes.paddingMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
