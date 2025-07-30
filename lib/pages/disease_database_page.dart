import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/disease.dart';
import 'package:vguard/services/disease_service.dart';
import 'package:vguard/widgets/disease_database_page/disease_item_card.dart';

class DiseaseDatabasePage extends StatefulWidget {
  const DiseaseDatabasePage({super.key});

  @override
  State<DiseaseDatabasePage> createState() => _DiseaseDatabasePageState();
}

class _DiseaseDatabasePageState extends State<DiseaseDatabasePage> {
  final DiseaseService _diseaseService = DiseaseService();
  late Future<List<Disease>> _diseasesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Disease> _allDiseases = []; // To hold all fetched diseases
  List<Disease> _filteredDiseases = []; // To hold filtered diseases

  @override
  void initState() {
    super.initState();
    _fetchDiseases(); // Initial fetch of all diseases
    _searchController.addListener(_filterDiseases);
  }

  void _fetchDiseases() {
    setState(() {
      _diseasesFuture = _diseaseService.getAllDiseases().then((diseases) {
        _allDiseases = diseases;
        _filterDiseases(); // Apply initial filter (empty search)
        return _allDiseases; // Return all diseases for the Future
      });
    });
  }

  void _filterDiseases() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDiseases =
          _allDiseases.where((disease) {
            // Search by disease name or category
            return disease.name.toLowerCase().contains(query) ||
                disease.category.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDiseases);
    _searchController.dispose();
    super.dispose();
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
                Text('Disease Database', style: AppTextStyles.pageHeaderTitle),
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
                    children: [
                      Card(
                        elevation: AppSizes.cardElevation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.borderRadiusMedium,
                          ),
                          side: BorderSide(color: AppColors.grey300),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.paddingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search Diseases',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black87,
                                ),
                              ),
                              SizedBox(height: AppSizes.paddingSmall + 4),
                              TextField(
                                controller:
                                    _searchController, // Assign controller
                                decoration: InputDecoration(
                                  hintText:
                                      'Search by disease name or crop type...',
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppColors.grey600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.grey100,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: AppSizes.paddingMedium,
                                    horizontal: AppSizes.paddingSmall + 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.verticalSpacing),
                      FutureBuilder<List<Disease>>(
                        future: _diseasesFuture, // Watch the future
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Center(
                                child: LoadingAnimationWidget.inkDrop(
                                  color: AppColors.primaryGreen,
                                  size: 30,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error loading diseases: ${snapshot.error}\n'
                                'Please ensure you have internet and Firebase rules allow reads.',
                              ),
                            );
                          } else if (snapshot.hasData &&
                              _filteredDiseases.isNotEmpty) {
                            // Display filtered diseases
                            return LayoutBuilder(
                              builder: (context, raints) {
                                int crossAxisCount =
                                    (raints.maxWidth > 600) ? 2 : 1;
                                // Adjust childAspectRatio as needed for your DiseaseItemCard
                                double childAspectRatio =
                                    (raints.maxWidth > 600) ? 2.0 : 1.5;

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
                                  itemCount: _filteredDiseases.length,
                                  itemBuilder: (context, index) {
                                    final disease = _filteredDiseases[index];

                                    String cardTitle = disease.name;

                                    String cardCrop = disease.category;

                                    String cardDescription =
                                        'Symptoms: ${disease.symptoms}\nTreatment: ${disease.treatment}\nPrevention: ${disease.prevention}';

                                    String cardRiskLevel;
                                    Color cardRiskColor;

                                    switch (disease.category.toLowerCase()) {
                                      case 'fungal':
                                      case 'bacterial':
                                        cardRiskLevel = 'High';
                                        cardRiskColor = AppColors.red;
                                        break;
                                      case 'viral':
                                        cardRiskLevel = 'Medium';
                                        cardRiskColor = AppColors.orange;
                                        break;
                                      case 'pest':
                                        cardRiskLevel = 'Low';
                                        cardRiskColor = AppColors.green;
                                        break;
                                      default:
                                        cardRiskLevel = 'Unknown';
                                        cardRiskColor = AppColors.grey200;
                                        break;
                                    }

                                    return DiseaseItemCard(
                                      title: cardTitle,
                                      crop: cardCrop,
                                      description: cardDescription,
                                      riskLevel: cardRiskLevel,
                                      riskColor: cardRiskColor,
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            // No data found or empty filtered list
                            return Center(
                              child: Text(
                                'No diseases found. Try a different search term.',
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
