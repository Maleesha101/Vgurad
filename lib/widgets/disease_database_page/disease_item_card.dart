import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/pages/disease_details.dart';

class DiseaseItemCard extends StatelessWidget {
  final String title;
  final String crop;
  final String description;
  final String riskLevel;
  final Color riskColor;

  const DiseaseItemCard({
    super.key,
    required this.title,
    required this.crop,
    required this.description,
    required this.riskLevel,
    required this.riskColor,
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: AppSizes.borderRadiusSmall,
                  ),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusSmall,
                    ),
                  ),
                  child: Text(
                    riskLevel,
                    style: TextStyle(
                      fontSize: 13,
                      color: riskColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Row(
              children: [
                Icon(
                  Icons.eco_outlined,
                  size: AppSizes.paddingMedium,
                  color: AppColors.grey600,
                ),
                SizedBox(width: AppSizes.borderRadiusSmall + 1),
                Text(
                  crop,
                  style: TextStyle(fontSize: 15, color: AppColors.grey700),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              description,
              style: TextStyle(fontSize: 15, color: AppColors.grey700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DiseaseDetailsPage(
                            diseaseName: title,
                            affectedCrop: crop,
                            severity: riskLevel,
                            cause: description,
                            symptoms: [
                              'Yellow spots',
                              'Brown edges',
                              'Wilting',
                            ], // Pass actual symptoms here
                            treatment:
                                'Copper fungicide spray', // Pass actual treatment here
                            prevention:
                                'Proper drainage, avoid overhead watering', // Pass actual prevention here
                          ),
                    ),
                  );
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
                child: Text('View Details', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
