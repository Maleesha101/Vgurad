import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/farmer_tip.dart';
import 'package:vguard/services/farmer_tip_service.dart';
import 'package:vguard/widgets/farmer_tips_page/category_chip.dart';
import 'package:vguard/widgets/farmer_tips_page/farming_tip_card.dart';
import 'package:vguard/widgets/farmer_tips_page/weather_alert_item.dart';

class FarmerTipsPage extends StatefulWidget {
  const FarmerTipsPage({super.key});

  @override
  State<FarmerTipsPage> createState() => _FarmerTipsPageState();
}

class _FarmerTipsPageState extends State<FarmerTipsPage> {
  final FarmerTipService _farmerTipService = FarmerTipService();
  late Future<List<FarmerTip>> _farmerTipsFuture;
  String _selectedCategory = 'All Tips';

  @override
  void initState() {
    super.initState();
    _fetchTips();
  }

  // Method to fetch tips based on the selected category
  void _fetchTips() {
    setState(() {
      if (_selectedCategory == 'All Tips') {
        _farmerTipsFuture = _farmerTipService.getAllFarmerTips();
      } else {
        _farmerTipsFuture = _farmerTipService.getFarmerTipsByCategory(
          _selectedCategory,
        );
      }
    });
  }

  // Callback for CategoryChip selection
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _fetchTips(); // Re-fetch tips when category changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: AppSizes.cardElevation,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 150,
          width: 150,
          fit: BoxFit.contain,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.lightGreenBackground,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingMedium,
            ),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMedium,
                      ),
                      side: BorderSide(color: AppColors.grey300),
                    ),
                    elevation: AppSizes.cardElevation,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                      vertical: AppSizes.paddingSmall + 4,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.horizontalSpacing),
                Text(
                  'Farmer Tips & Advice',
                  style: AppTextStyles.pageHeaderTitle,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.paddingLarge),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weather Alerts', style: AppTextStyles.sectionTitle),
                      SizedBox(height: AppSizes.paddingMedium),
                      Card(
                        elevation: AppSizes.cardElevation,
                        color: AppColors.yellowBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.borderRadiusMedium,
                          ),
                          side: BorderSide(color: AppColors.amber200),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.paddingLarge),
                          child: Column(
                            children: [
                              WeatherAlertItem(
                                icon: Icons.cloud_outlined,
                                title: 'Heavy Rain Expected',
                                description:
                                    'Prepare drainage and avoid fertilizer application for next 3 days',
                                iconColor: AppColors.amber700,
                              ),
                              Divider(
                                height: AppSizes.paddingXXLarge,
                                thickness: AppSizes.dividerThickness,
                                color: AppColors.amber,
                              ),
                              WeatherAlertItem(
                                icon: Icons.wb_sunny_outlined,
                                title: 'Optimal Planting Weather',
                                description:
                                    'Current conditions are ideal for planting rice and vegetables',
                                iconColor: AppColors.amber700,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXXLarge),

                      Text(
                        'Filter by Category',
                        style: AppTextStyles.sectionTitle,
                      ),
                      SizedBox(height: AppSizes.paddingMedium),
                      Wrap(
                        spacing: AppSizes.paddingSmall + 2,
                        runSpacing: AppSizes.paddingSmall + 2,
                        children: [
                          // Dynamically create CategoryChips
                          CategoryChip(
                            label: 'All Tips',
                            isSelected: _selectedCategory == 'All Tips',
                            onPressed: () => _onCategorySelected('All Tips'),
                          ),
                          CategoryChip(
                            label: 'Seasonal',
                            isSelected: _selectedCategory == 'Seasonal',
                            onPressed: () => _onCategorySelected('Seasonal'),
                          ),
                          CategoryChip(
                            label: 'Weather',
                            isSelected: _selectedCategory == 'Weather',
                            onPressed: () => _onCategorySelected('Weather'),
                          ),
                          CategoryChip(
                            label: 'Pest Management',
                            isSelected: _selectedCategory == 'Pest Management',
                            onPressed:
                                () => _onCategorySelected('Pest Management'),
                          ),
                          CategoryChip(
                            label: 'Harvest',
                            isSelected: _selectedCategory == 'Harvest',
                            onPressed: () => _onCategorySelected('Harvest'),
                          ),
                          CategoryChip(
                            label: 'Soil Care',
                            isSelected: _selectedCategory == 'Soil Care',
                            onPressed: () => _onCategorySelected('Soil Care'),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.paddingXXLarge),

                      FutureBuilder<List<FarmerTip>>(
                        future: _farmerTipsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LoadingAnimationWidget.inkDrop(
                                color: AppColors.primaryGreen,
                                size: 30,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error loading tips: ${snapshot.error}\n'
                                'Please ensure you have internet and Firebase rules allow reads.',
                              ),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            // Data loaded successfully
                            return LayoutBuilder(
                              builder: (context, raints) {
                                int crossAxisCount =
                                    (raints.maxWidth > 600) ? 2 : 1;
                                double childAspectRatio =
                                    (raints.maxWidth > 600) ? 1.0 : 1.0;

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: childAspectRatio,
                                        mainAxisSpacing:
                                            AppSizes.verticalSpacing,
                                        crossAxisSpacing:
                                            AppSizes.horizontalSpacing,
                                      ),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final tip = snapshot.data![index];
                                    Color tagColor;
                                    switch (tip.category) {
                                      case 'Seasonal':
                                        tagColor = AppColors.teal;
                                        break;
                                      case 'Weather':
                                        tagColor = AppColors.orange;
                                        break;
                                      case 'Pest Management':
                                        tagColor = AppColors.pink;
                                        break;
                                      case 'Harvest':
                                        tagColor = AppColors.purple;
                                        break;
                                      case 'Soil Care':
                                        tagColor = AppColors.amber;
                                        break;
                                      default:
                                        tagColor = AppColors.blueGrey;
                                    }

                                    // Determine icon based on category
                                    IconData icon;
                                    switch (tip.category) {
                                      case 'Seasonal':
                                        icon = Icons.eco_outlined;
                                        break;
                                      case 'Weather':
                                        icon = Icons.wb_sunny_outlined;
                                        break;
                                      case 'Pest Management':
                                        icon = Icons.bug_report_outlined;
                                        break;
                                      case 'Harvest':
                                        icon = Icons.grass_outlined;
                                        break;
                                      case 'Soil Care':
                                        icon = Icons.landscape_outlined;
                                        break;
                                      default:
                                        icon = Icons.lightbulb_outline;
                                    }

                                    return FarmingTipCard(
                                      title: tip.title,
                                      dateRange:
                                          '${tip.dateAdded.year}-${tip.dateAdded.month.toString().padLeft(2, '0')}-${tip.dateAdded.day.toString().padLeft(2, '0')}',
                                      season: tip.category,
                                      tips: [tip.content],
                                      tag: tip.category,
                                      tagColor: tagColor,
                                      icon: icon,
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            // No data found or empty list
                            return Center(
                              child: Text(
                                'No farmer tips found for this category.',
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
