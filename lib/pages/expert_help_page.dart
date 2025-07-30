import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/expert.dart';
import 'package:vguard/services/expert_service.dart';
import 'package:vguard/widgets/expert_help_page/expert_card.dart';
import 'package:vguard/widgets/expert_help_page/expert_tab_button.dart';

class ExpertHelpPage extends StatefulWidget {
  const ExpertHelpPage({super.key});

  @override
  State<ExpertHelpPage> createState() => _ExpertHelpPageState();
}

class _ExpertHelpPageState extends State<ExpertHelpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ExpertService _expertService = ExpertService();
  late Future<List<Expert>> _expertsFuture; // Future to hold experts data

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _expertsFuture = _expertService.getExperts();

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
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
                Text('Expert Help', style: AppTextStyles.pageHeaderTitle),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingSmall * 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ExpertTabButton(
                    label: 'Experts',
                    icon: Icons.person_outline,
                    isSelected: _tabController.index == 0,
                    onPressed: () {
                      _tabController.animateTo(0);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ExpertTabButton(
                    label: 'Ask Question',
                    icon: Icons.question_answer_outlined,
                    isSelected: _tabController.index == 1,
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ExpertTabButton(
                    label: 'My Questions',
                    icon: Icons.history,
                    isSelected: _tabController.index == 2,
                    onPressed: () {
                      _tabController.animateTo(2);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.paddingXXLarge),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAgriculturalExpertsTab(), // Content for 'Experts' tab
                _buildAskQuestionTab(), // Content for 'Ask Question' tab
                _buildMyQuestionsTab(), // Content for 'My Questions' tab
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget for the "Experts" tab, now fetching from Firebase ---
  Widget _buildAgriculturalExpertsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Agricultural Experts',
                style: AppTextStyles.sectionTitle,
              ),
              SizedBox(height: AppSizes.paddingMedium),
              FutureBuilder<List<Expert>>(
                future: _expertsFuture, // Use the Future that fetches data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: AppColors.primaryGreen,
                        size: 30,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading experts: ${snapshot.error}\n'
                        'Please ensure you have internet and Firebase rules allow reads.',
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Data loaded successfully
                    return LayoutBuilder(
                      builder: (context, raints) {
                        int crossAxisCount = (raints.maxWidth > 700) ? 2 : 1;
                        double childAspectRatio =
                            (raints.maxWidth > 700) ? 1.5 : 1.2;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                mainAxisSpacing: AppSizes.verticalSpacing,
                                crossAxisSpacing: AppSizes.horizontalSpacing,
                              ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final expert = snapshot.data![index];
                            return ExpertCard(
                              name: expert.name,
                              specialty: expert.specialty,
                              experience: expert.experience,
                              languages: expert.languages,
                              rating: expert.rating,
                            );
                          },
                        );
                      },
                    );
                  } else {
                    // No data found or empty list
                    return Center(
                      child: Text('No agricultural experts found.'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget for the "Ask Question" tab ---
  Widget _buildAskQuestionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: AppSizes.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submit Your Question',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black87,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingLarge),
                  Text(
                    'Your Question',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingSmall),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Describe your crop problem in detail...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusSmall,
                        ),
                        borderSide: BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusSmall,
                        ),
                        borderSide: BorderSide(color: AppColors.grey300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusSmall,
                        ),
                        borderSide: BorderSide(
                          color: AppColors.primaryGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingLarge),
                  Text(
                    'Attach Photo (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingSmall),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      border: Border.all(
                        color: AppColors.grey300,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusSmall,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: AppSizes.iconSizeLarge,
                            color: AppColors.grey600,
                          ),
                          SizedBox(height: AppSizes.paddingSmall),
                          Text(
                            'Click to upload photo',
                            style: TextStyle(color: AppColors.grey600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingLarge),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle submit question
                        print('Submit Question tapped!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.borderRadiusMedium,
                          ),
                        ),
                      ),
                      icon: Icon(Icons.send),
                      label: Text('Submit Question'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget for the "My Questions" tab ---
  Widget _buildMyQuestionsTab() {
    return Center(child: Text('My Questions Content Here'));
  }
}
