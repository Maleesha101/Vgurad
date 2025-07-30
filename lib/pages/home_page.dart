import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/core/app_routes.dart';
import 'package:vguard/services/auth_service.dart';
import 'package:vguard/widgets/auth/login_popup.dart';
import 'package:vguard/widgets/home_page/farming_conditions_section.dart';
import 'package:vguard/widgets/home_page/feature_cards_section.dart';
import 'package:vguard/widgets/home_page/hero_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  void _showLoginPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginPopup();
      },
    );
  }

  // Function to handle sign out
  void _handleSignOut() async {
    /// await _authService.signOut();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logged out successfully!')));
    }
  }

  // Define the admin email
  static final String _adminEmail = 'admin@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.askAdvisor);
        },
        backgroundColor: AppColors.darkGreen,
        child: Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: AppSizes.cardElevation,
        title: Image.asset(
          'assets/images/logo.png',
          height: 150,
          width: 150,
          fit: BoxFit.contain,
        ),
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.darkGreen, AppColors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          StreamBuilder<User?>(
            stream: _authService.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: AppColors.white);
              } else if (snapshot.hasData && snapshot.data != null) {
                // User is logged in
                final User? user = snapshot.data;
                final bool isAdmin = user?.email == _adminEmail;

                if (isAdmin) {
                  // Admin user - display Admin button and Logout
                  return Padding(
                    padding: EdgeInsets.all(AppSizes.paddingSmall),
                    child: Row(
                      children: [
                        // Admin Panel button
                        TextButton(
                          onPressed: () {
                            // If current route is not admin dashboard, navigate to it
                            if (ModalRoute.of(context)?.settings.name !=
                                AppRoutes.adminDashboard) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.adminDashboard,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.darkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.borderRadiusMedium,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingMedium,
                            ),
                          ),
                          child: Text(
                            'Admin Panel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingSmall),
                        // Logout button for Admin
                        IconButton(
                          icon: Icon(Icons.logout, color: AppColors.white),
                          onPressed: _handleSignOut,
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  );
                } else {
                  // Regular logged-in user - display user email and Logout
                  return Padding(
                    padding: EdgeInsets.all(AppSizes.paddingSmall),
                    child: Row(
                      children: [
                        Text(
                          user?.displayName ?? user?.email ?? 'User',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingSmall),
                        IconButton(
                          icon: Icon(Icons.logout, color: AppColors.white),
                          onPressed: _handleSignOut,
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  );
                }
              } else {
                // User is not logged in - display Login button
                return Padding(
                  padding: EdgeInsets.all(AppSizes.paddingSmall),
                  child: TextButton(
                    onPressed: _showLoginPopup,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusMedium,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMedium,
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(width: AppSizes.paddingSmall),
        ],
      ),
      // Body content changes based on user role
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            final User? user = snapshot.data;
            final bool isAdmin = user?.email == _adminEmail;

            if (isAdmin) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ModalRoute.of(context)?.settings.name !=
                    AppRoutes.adminDashboard) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.adminDashboard,
                  );
                }
              });
              return Container();
            } else {
              // If regular user, show regular content
              return _buildRegularUserContent();
            }
          } else {
            // If not logged in, show regular content (public view)
            return _buildRegularUserContent();
          }
        },
      ),
    );
  }

  // Method to build content for regular users and logged-out state
  Widget _buildRegularUserContent() {
    double size = MediaQuery.of(context).size.height;
    Logger().i('&size: $size');
    return SingleChildScrollView(
      child: Column(
        children: [
          HeroSection(),
          SizedBox(height: AppSizes.paddingXXLarge),
          FeatureCardsSection(),
          SizedBox(height: AppSizes.paddingXXLarge),
          FarmingConditionsSection(),
          SizedBox(height: AppSizes.paddingXXLarge),
        ],
      ),
    );
  }
}
