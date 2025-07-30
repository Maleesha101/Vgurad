import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: AppSizes.cardElevation * 0.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        side: BorderSide(
          color:
              backgroundColor == null ? AppColors.grey200 : AppColors.amber200,
        ),
      ),
      color: backgroundColor ?? AppColors.lightGreenBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Width * 0.02,
          horizontal: Width * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color:
                    backgroundColor == null
                        ? AppColors.primaryGreen
                        : AppColors.black87,
                fontSize: Width * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.005),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    backgroundColor == null
                        ? AppColors.grey700
                        : AppColors.grey700,
                fontSize: Width * 0.014,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
