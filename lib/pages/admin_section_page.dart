import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/services/auth_service.dart';
import 'package:vguard/widgets/admin/disease_management_tab.dart';
import 'package:vguard/widgets/admin/expert_management_tab.dart';
import 'package:vguard/widgets/admin/farmer_tips_management_tab.dart';

class AdminSectionPage extends StatefulWidget {
  const AdminSectionPage({super.key});

  @override
  State<AdminSectionPage> createState() => _AdminSectionPageState();
}

class _AdminSectionPageState extends State<AdminSectionPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late TabController _tabController;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSignOut() async {
    await _authService.signOut();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logged out from Admin section.')));
      Navigator.of(context).pushReplacementNamed('/'); // Navigate to home route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            width: 110,
            height: 40,
            margin: EdgeInsets.only(right: AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              border: Border.all(
                color: AppColors.white.withOpacity(0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: InkWell(
                onTap: _handleSignOut,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.logout, color: AppColors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin Dashboard Title and Subtitle
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingMedium,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Dashboard',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.black87,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingSmall / 2),
                  Text(
                    'Manage disease database, farmer tips, and expert help content',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: AppSizes.paddingMedium,
          ), // Space between title and tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
            child: Container(
              color: AppColors.grey200,
              child: TabBar(
                controller: _tabController,
                onTap: (value) {
                  setState(() {
                    isSelected = value == 0;
                  });
                },
                indicatorColor: AppColors.primaryGreen,
                labelColor: AppColors.black87,
                unselectedLabelColor: AppColors.grey600,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                dividerHeight: 0,
                tabs: [
                  Tab(text: 'Disease Database'),
                  Tab(text: 'Farmer Tips'),
                  Tab(text: 'Expert Help'),
                ],
              ),
            ),
          ),

          // Tab Bar View (Content for each tab)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingSmall * 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey300, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TabBarView(
                  controller: _tabController,
                  children: [
                    DiseaseManagementTab(),
                    FarmerTipsManagementTab(),
                    ExpertManagementTab(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
