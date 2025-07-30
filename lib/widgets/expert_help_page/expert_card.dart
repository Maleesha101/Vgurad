import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';

class ExpertCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String experience;
  final List<String> languages;
  final double rating;

  const ExpertCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.languages,
    required this.rating,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 15, color: AppColors.grey700),
                    ),
                    SizedBox(width: AppSizes.borderRadiusSmall),
                    Icon(
                      Icons.star,
                      color: AppColors.amber,
                      size: AppSizes.iconSizeSmall,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              specialty,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.grey700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.borderRadiusSmall),
            Text(
              experience,
              style: TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
            SizedBox(height: AppSizes.paddingSmall + 4),
            Text(
              'Languages:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Wrap(
              spacing: AppSizes.paddingSmall,
              runSpacing: AppSizes.paddingSmall,
              children:
                  languages
                      .map(
                        (lang) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmall + 2,
                            vertical: AppSizes.borderRadiusSmall + 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(
                              AppSizes.borderRadiusSmall + 1,
                            ),
                            border: Border.all(color: AppColors.grey300),
                          ),
                          child: Text(
                            lang,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print('Call Now for $name tapped!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.paddingMedium - 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusMedium,
                        ),
                      ),
                      elevation: AppSizes.cardElevation,
                    ),
                    child: Text('Call Now'),
                  ),
                ),
                SizedBox(width: AppSizes.paddingSmall + 2),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      print('Chat for $name tapped!');
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
                    child: Text('Chat'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
