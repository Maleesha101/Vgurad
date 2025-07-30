import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class FarmingTipCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String season;
  final List<String> tips;
  final String tag;
  final Color tagColor;
  final IconData icon;

  const FarmingTipCard({
    super.key,
    required this.title,
    required this.dateRange,
    required this.season,
    required this.tips,
    required this.tag,
    required this.tagColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        side: BorderSide(color: AppColors.grey300),
      ),
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconSizeLarge,
                  color: AppColors.primaryGreen,
                ),
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
                      SizedBox(height: AppSizes.borderRadiusSmall),
                      Text(
                        dateRange,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: AppSizes.borderRadiusSmall,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusSmall,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 13,
                      color: tagColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Season: $season',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall + 2),
            ...tips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(bottom: AppSizes.paddingSmall - 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: AppSizes.paddingSmall,
                      color: AppColors.primaryGreen,
                    ),
                    SizedBox(width: AppSizes.paddingSmall),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  print('Save to My Notes for $title tapped!');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: BorderSide(color: AppColors.primaryGreen),
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMedium - 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                  ),
                ),
                child: Text('Save to My Notes', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
