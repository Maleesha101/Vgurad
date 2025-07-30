import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class WeatherAlertItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const WeatherAlertItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSizeLarge, color: iconColor),
          SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  ),
                ),
                SizedBox(height: AppSizes.borderRadiusSmall + 1),
                Text(
                  description,
                  style: TextStyle(fontSize: 15, color: AppColors.grey700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
