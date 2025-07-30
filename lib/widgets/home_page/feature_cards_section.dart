import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/core/app_routes.dart';
import 'package:vguard/widgets/common/feature_card.dart';

class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        constraints: BoxConstraints(maxWidth: 1200),
        child: LayoutBuilder(
          builder: (context, raints) {
            int crossAxisCount;
            if (raints.maxWidth > 900) {
              crossAxisCount = 2;
            } else if (raints.maxWidth > 600) {
              crossAxisCount = 2;
            } else {
              crossAxisCount = 1;
            }

            double childAspectRatio = (raints.maxWidth > 900) ? 2.5 : 2.0;
            if (crossAxisCount == 1) {
              childAspectRatio = 3.0;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: AppSizes.verticalSpacing,
              crossAxisSpacing: AppSizes.horizontalSpacing,
              children: [
                FeatureCard(
                  icon: Icons.camera_alt_outlined,
                  title: 'Scan Your Crop',
                  description:
                      'To detect diseases and get instant treatment recommendations',
                  buttonText: 'Scan Your Crop',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.scanCrop);
                  },
                ),
                FeatureCard(
                  icon: Icons.book_outlined,
                  title: 'Disease Database',
                  description:
                      'Browse comprehensive information about crop diseases and treatments',
                  buttonText: 'Disease Database',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.diseaseDatabase);
                  },
                ),
                FeatureCard(
                  icon: Icons.lightbulb_outline,
                  title: 'Farmer Tips',
                  description:
                      'Get seasonal advice, weather alerts, and expert farming tips',
                  buttonText: 'Farmer Tips',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.farmerTips);
                  },
                ),
                FeatureCard(
                  icon: Icons.phone_in_talk_outlined,
                  title: 'Expert Help',
                  description:
                      'Connect with agricultural experts for personalized assistance',
                  buttonText: 'Expert Help',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, AppRoutes.expertHelp);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
