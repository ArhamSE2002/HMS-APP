// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  late Animation<double> _gradientAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  final authController = Get.put(AuthController(), permanent: true);

  @override
  void initState() {
    super.initState();

    // Gradient animation controller
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _gradientAnimation = CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    );

    // Scale animation for logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Pulse animation for icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _fadeController.forward();
    });

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        authController.checkAuth();
      }
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Gradient Background
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(
                        0.8 + 0.2 * _gradientAnimation.value,
                      ),
                      AppColors.secondary.withOpacity(
                        0.8 + 0.2 * (1 - _gradientAnimation.value),
                      ),
                      AppColors.accent.withOpacity(
                        0.6 + 0.4 * _gradientAnimation.value,
                      ),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating particles effect
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _gradientAnimation,
              builder: (context, child) {
                return Positioned(
                  left:
                      (width * 0.1) +
                      (index * width * 0.04) +
                      (50 *
                          _gradientAnimation.value *
                          (index % 2 == 0 ? 1 : -1)),
                  top:
                      (height * 0.1) +
                      (index * height * 0.04) +
                      (30 * _gradientAnimation.value),
                  child: Opacity(
                    opacity: 0.1 + (0.2 * _gradientAnimation.value),
                    child: Container(
                      width: 8 + (4 * (index % 3)),
                      height: 8 + (4 * (index % 3)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo Icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: width * 0.35,
                        height: width * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(
                                0.3 * _pulseAnimation.value,
                              ),
                              blurRadius: 40 + (20 * _pulseAnimation.value),
                              spreadRadius: 10 + (10 * _pulseAnimation.value),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: width * 0.28,
                            height: width * 0.28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.85),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.local_hospital_rounded,
                              size: width * 0.16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: height * 0.06),

                // App Title with Fade Animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Hospital Finance',
                        style: TextStyle(
                          fontSize: width * 0.11,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.5,
                          height: 1,
                          shadows: [
                            Shadow(
                              blurRadius: 30,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 10),
                            ),
                            Shadow(
                              blurRadius: 15,
                              color: AppColors.primary.withOpacity(0.5),
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.015),
                      Text(
                        'Manage Your Revenue',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.08),

                // Loading Indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedBuilder(
                    animation: _gradientAnimation,
                    builder: (context, child) {
                      return Container(
                        width: width * 0.15,
                        height: width * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom branding
          Positioned(
            bottom: height * 0.05,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Powered by Modern Technology',
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: height * 0.008),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureDot(width),
                      SizedBox(width: width * 0.03),
                      Text(
                        'Secure',
                        style: TextStyle(
                          fontSize: width * 0.028,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      _buildFeatureDot(width),
                      SizedBox(width: width * 0.03),
                      Text(
                        'Fast',
                        style: TextStyle(
                          fontSize: width * 0.028,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      _buildFeatureDot(width),
                      SizedBox(width: width * 0.03),
                      Text(
                        'Reliable',
                        style: TextStyle(
                          fontSize: width * 0.028,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureDot(double width) {
    return Container(
      width: width * 0.015,
      height: width * 0.015,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}
