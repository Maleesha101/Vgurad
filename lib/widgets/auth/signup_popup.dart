import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/services/auth_service.dart';

class SignUpPopup extends StatefulWidget {
  const SignUpPopup({super.key});

  @override
  State<SignUpPopup> createState() => _SignUpPopupState();
}

class _SignUpPopupState extends State<SignUpPopup> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  void _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Set display name
      await _authService.getCurrentUser()?.updateDisplayName(
        _fullNameController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(); // Close the popup on successful sign-up
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        ); // Clean up error message
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      ///   await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pop(); // Close the popup on successful sign-up
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed up with Google successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      ),
      child: Container(
        width: 450,
        height: 580,
        padding: EdgeInsets.all(AppSizes.paddingXLarge),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: AppColors.grey600),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.paddingMedium),
              Text(
                'Create a new account to get started',
                style: TextStyle(fontSize: 16, color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.paddingXLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.black87,
                    side: BorderSide(color: AppColors.grey300),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusMedium,
                      ),
                    ),
                    elevation: 1,
                  ),
                  icon: Image.asset(
                    'assets/icons/google_logo.png',
                    height: 24,
                  ), // Re-use Google logo
                  label: Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),
              Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.grey600,
                  ),
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMedium,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.grey600,
                  ),
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMedium,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSizes.paddingMedium),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.grey600,
                  ),
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingMedium,
                  ),
                ),
                obscureText: true,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.paddingSmall),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.red, fontSize: 13),
                  ),
                ),
              SizedBox(height: AppSizes.paddingXLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signUp,
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
                    elevation: AppSizes.cardElevation,
                  ),
                  icon:
                      _isLoading
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Icon(Icons.person_add_alt_1),
                  label: Text(
                    _isLoading ? 'Creating Account...' : 'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close signup popup
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(fontSize: 14, color: AppColors.grey600),
                    children: [
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
