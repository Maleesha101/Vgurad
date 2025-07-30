import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/widgets/common/pill_button.dart';
import 'package:vguard/widgets/common/stat_card.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: screenWidth * 0.98,
          height: screenWidth < 600 ? 250 : 300,
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.paddingHeroVertical,
            horizontal: screenWidth * 0.05,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/hero.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.darken,
              ),
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGreen.withOpacity(0.2),
                AppColors.darkGreen.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protect Your Crops with AI',
                      style: AppTextStyles.heroTitle,
                    ),
                    const SizedBox(height: AppSizes.paddingMedium),
                    const Text(
                      'Detect diseases early, get expert treatment advice, and keep your farm healthy with Vguard\'s intelligent crop protection system.',
                      style: AppTextStyles.heroDescription,
                    ),
                    SizedBox(height: AppSizes.paddingXXLarge),
                    Wrap(
                      spacing: AppSizes.paddingSmall + 4,
                      runSpacing: AppSizes.paddingSmall + 4,
                      children: [
                        PillButton(
                          text: 'AI Disease Detection',
                          icon: Icons.lightbulb_outline,
                        ),
                        PillButton(
                          text: 'Expert Advice',
                          icon: Icons.person_outline,
                        ),
                        PillButton(
                          text: 'Organic Solutions',
                          icon: Icons.eco_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: (AppSizes.paddingHeroVertical) * 0.5),
        SizedBox(
          width: screenWidth * 0.98,
          child: GridView.count(
            crossAxisCount: screenWidth < 600 ? 2 : 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio:
                screenWidth < 600 ? 1.8 : 2.2, // Made taller for small screens
            crossAxisSpacing: AppSizes.horizontalSpacing,
            mainAxisSpacing: AppSizes.horizontalSpacing,
            children: [
              StatCard(value: '50+', label: 'Diseases Detected'),
              StatCard(value: '1000+', label: 'Farmers Helped'),
              StatCard(
                value: '24/7',
                label: 'Expert Support',
                backgroundColor: AppColors.yellowBackground,
              ),
              StatCard(value: '95%', label: 'Accuracy Rate'),
            ],
          ),
        ),
      ],
    );
  }
}
