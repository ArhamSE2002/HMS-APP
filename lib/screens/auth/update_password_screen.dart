// lib/screens/update_password_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import '../../utils/app_colors.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _hospitalIdController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  final authController = Get.find<AuthController>();

  Future<void> handleUpdate() async {
    print("Update Password Called");
    // await authController.updatePassword(
    //   "accounts/update-password",
    //   _hospitalIdController.text,
    //   _oldPasswordController.text,
    //   _newPasswordController.text,
    // );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hospitalIdController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.background,
                  AppColors.secondary.withOpacity(0.08),
                ],
              ),
            ),
          ),

          // Circles
          Positioned(
            top: -height * 0.15,
            right: -width * 0.2,
            child: Container(
              width: width * 0.6,
              height: width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -height * 0.1,
            left: -width * 0.15,
            child: Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.12),
                    AppColors.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.08),

                    // Logo + Heading (exact sizes from LoginScreen)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Container(
                            width: width * 0.25,
                            height: width * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: width * 0.13,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            'Update Password',
                            style: TextStyle(
                              fontSize:
                                  width *
                                  0.08, // same as LoginScreen "Welcome Back"
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            'Secure your account',
                            style: TextStyle(
                              fontSize:
                                  width * 0.042, // same as Sign in subtext
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.06),

                    // Form (same transitions)
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Hospital ID (uses same _buildInputField exact styles)
                              _buildInputField(
                                controller: _hospitalIdController,
                                label: 'Hospital ID',
                                hint: 'Enter your hospital ID',
                                icon: Icons.person_rounded,
                                width: width,
                                height: height,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your hospital ID';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.025),

                              // Previous Password (exact same styles as password in LoginScreen)
                              _buildInputField(
                                controller: _oldPasswordController,
                                label: 'Previous Password',
                                hint: 'Enter your previous password',
                                icon: Icons.lock_rounded,
                                isPassword: true,
                                width: width,
                                height: height,
                                passwordVisibilityFlag: _isOldPasswordVisible,
                                onPasswordToggle: () {
                                  setState(
                                    () =>
                                        _isOldPasswordVisible =
                                            !_isOldPasswordVisible,
                                  );
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your previous password';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.025),

                              // New Password
                              _buildInputField(
                                controller: _newPasswordController,
                                label: 'New Password',
                                hint: 'Enter your new password',
                                icon: Icons.lock_rounded,
                                isPassword: true,
                                width: width,
                                height: height,
                                passwordVisibilityFlag: _isNewPasswordVisible,
                                onPasswordToggle: () {
                                  setState(
                                    () =>
                                        _isNewPasswordVisible =
                                            !_isNewPasswordVisible,
                                  );
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your new password';
                                  }
                                  if (value.length < 4) {
                                    return 'Password must be at least 4 characters';
                                  }
                                  return null;
                                },
                              ),

                              // Forgot Password align kept intentionally (you can remove if not needed)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: width * 0.036,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.03),

                              Obx(() {
                                return _buildSubmitButton(width, height, () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    handleUpdate();
                                  }
                                });
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.04),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.security_rounded,
                                size: width * 0.04,
                                color: AppColors.success,
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                'Secure Login',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: width * 0.032,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.015),
                          Text(
                            'Hospital Finance Management v1.0',
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontSize: width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          ),

          // NOTE: not showing the global loading overlay here because the LoginScreen only showed it conditionally with _isLoading.
          // If you used the overlay in login, copy same overlay logic here. Keeping consistent with your LoginScreen's button+AuthController loading.
        ],
      ),
    );
  }

  // Reusable input field copied precisely from your LoginScreen (same sizes, prefix decoration, text styles, paddings)
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required double width,
    required double height,
    bool isPassword = false,
    String? Function(String?)? validator,
    // extra params for password to handle separate visibility toggles
    bool passwordVisibilityFlag = false,
    VoidCallback? onPasswordToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !passwordVisibilityFlag,
        validator: validator,
        style: TextStyle(
          fontSize: width * 0.042, // same as LoginScreen
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
            fontSize: width * 0.038,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(width * 0.03),
            padding: EdgeInsets.all(width * 0.02),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.secondary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(width * 0.025),
            ),
            child: Icon(icon, color: AppColors.primary, size: width * 0.055),
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      passwordVisibilityFlag
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textSecondary,
                      size: width * 0.055,
                    ),
                    onPressed: onPasswordToggle,
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.04),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.022,
          ),
        ),
      ),
    );
  }

  // Submit button replicated exactly (sizes, gradients, shadows)
  Widget _buildSubmitButton(
    double width,
    double height,
    void Function() ontap,
  ) {
    return Container(
      width: double.infinity,
      height: height * 0.07,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(width * 0.04),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: authController.isLoading.value ? null : ontap,
          borderRadius: BorderRadius.circular(width * 0.04),
          child: Center(
            child:
                authController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text(
                      'Update Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w700,
                        // letterSpacing: 1,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
