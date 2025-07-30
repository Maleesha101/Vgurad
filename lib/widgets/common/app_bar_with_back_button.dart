import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class CustomAppBarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarWithBackButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      elevation: AppSizes.cardElevation,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          Icon(Icons.shield, color: AppColors.white),
          SizedBox(width: AppSizes.paddingSmall),
          Text(title, style: AppTextStyles.appBarTitle),
        ],
      ),
      actions: [
        Container(
          width: AppSizes.iconSizeXXLarge,
          height: AppSizes.iconSizeXXLarge,
          margin: EdgeInsets.only(right: AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
