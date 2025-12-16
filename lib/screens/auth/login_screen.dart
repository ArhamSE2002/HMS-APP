// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import 'package:khaiyal_hospital_finance/screens/auth/update_password_screen.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final authController = Get.find<AuthController>();

  Future<void> handleLogin() async {
    print("Handle Login Called");
    await authController.login(
      "accounts/login",
      _userIdController.text,
      _passwordController.text,
    );
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
    _userIdController.dispose();
    _passwordController.dispose();
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

                    // Logo + Welcome
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
                              Icons.local_hospital_rounded,
                              size: width * 0.13,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: width * 0.08,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: width * 0.042,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.06),

                    // Form Section
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                controller: _userIdController,
                                label: 'User ID',
                                hint: 'Enter your user ID',
                                icon: Icons.person_rounded,
                                width: width,
                                height: height,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your user ID';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.025),

                              _buildInputField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Enter your password',
                                icon: Icons.lock_rounded,
                                isPassword: true,
                                width: width,
                                height: height,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 4) {
                                    return 'Password must be at least 4 characters';
                                  }
                                  return null;
                                },
                              ),

                              // SizedBox(height: height * 0.015),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(UpdatePasswordScreen());
                                  },
                                  child: Text(
                                    'Update Password?',
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
                                return _buildLoginButton(
                                  width,
                                  height,
                                  handleLogin,
                                );
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

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(width * 0.08),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Logging in...',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // -------------------------
  // Reusable Widgets
  // -------------------------
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required double width,
    required double height,
    bool isPassword = false,
    String? Function(String?)? validator,
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
        obscureText: isPassword && !_isPasswordVisible,
        validator: validator,
        style: TextStyle(
          fontSize: width * 0.042,
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
                      _isPasswordVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textSecondary,
                      size: width * 0.055,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
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

  Widget _buildLoginButton(double width, double height, void Function() ontap) {
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
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
