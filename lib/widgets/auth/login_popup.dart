import 'package:flutter/material.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/services/auth_service.dart';
import 'package:vguard/widgets/auth/signup_popup.dart';

class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(); // Close the popup on successful login
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logged in successfully!')));
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
      await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pop(); // Close the popup on successful login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot sign in with Google yet')),
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

  void _showSignUpPopup() {
    Navigator.of(context).pop(); // Close login popup first
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignUpPopup(); // Show the signup popup
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 100),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      ),
      child: Container(
        width: 450,
        height: 530,
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
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.paddingMedium),
              Text(
                'Sign in to your account to continue',
                style: TextStyle(fontSize: 16, color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.paddingXLarge),
              SizedBox(
                width: double.infinity,
                height: 45,
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
                  icon: Image.asset('assets/icons/google_logo.png', height: 24),
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
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
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
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                    borderSide: BorderSide(
                      color: AppColors.white70.withOpacity(0.1),
                    ),
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
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusMedium,
                    ),
                    borderSide: BorderSide(
                      color: AppColors.white70.withOpacity(0.1),
                    ),
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
                  onPressed: _isLoading ? null : _signIn,
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
                          : Icon(Icons.login),
                  label: Text(
                    _isLoading ? 'Signing In...' : 'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.paddingMedium),
              TextButton(
                onPressed:
                    _isLoading
                        ? null
                        : _showSignUpPopup, // Link to signup popup
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(fontSize: 14, color: AppColors.grey600),
                    children: [
                      TextSpan(
                        text: 'Sign up',
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
