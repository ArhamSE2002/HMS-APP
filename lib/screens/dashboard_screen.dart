import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import 'package:khaiyal_hospital_finance/controllers/dashboardController.dart';
import 'package:khaiyal_hospital_finance/screens/request_screen.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_colors.dart';
import 'department_detail_screen.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final authController = Get.find<AuthController>();
  final dashboardController = Get.put(DashboardController());

  final List<Color> colors = [
    Color(0xFF355070), // primary
    Color(0xFF6D597A), // secondary
    Color(0xFFB56576), // accent
    Color(0xFFE56B6F), // highlight
    Color(0xFFEAAC8B), // warm
    Color(0xFFF8F9FA), // background
    Color(0xFFFFFFFF), // cardBackground
    Color(0xFF2C3E50), // textPrimary
    Color(0xFF7F8C8D), // textSecondary
    Color(0xFF27AE60), // success
    Color(0xFFF39C12), // warning
    Color(0xFFE74C3C),
  ];

  final Map<String, IconData> departmentIcons = {
    "pharmacy": Icons.local_pharmacy_rounded,
    "ipd": Icons.healing_rounded,
    "patient_visit": Icons.groups_rounded,
    "lab": Icons.science_rounded,
    "emergency": Icons.warning_rounded,
  };

  final Map<String, Color> departmentColors = {
    "pharmacy": AppColors.error,
    "ipd": AppColors.primary,
    "patient_visit": AppColors.success,
    "lab": AppColors.highlight,
    "emergency": AppColors.warm,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Obx(() {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.03),
                      AppColors.secondary.withOpacity(0.02),
                      AppColors.warm.withOpacity(0.04),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Header =====
                    FadeTransition(
                      opacity: _animationController,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          bottom: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Welcome Back',
                                        style: TextStyle(
                                          fontSize: width * 0.035,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      // SizedBox(width: 5),
                                      // Icon(
                                      //   Icons.medical_information,
                                      //   color: Colors.blueGrey,
                                      //   size: 14,
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.006),
                                  SizedBox(
                                    height: height * 0.035,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        authController.logout();
                                      },
                                      child: Text(
                                        authController.userData == null
                                            ? 'Hospital Owner'
                                            : authController
                                                .userData["username"]
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: width * 0.068,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.8,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Text(
                                    'HMS Financial Dashboard',
                                    style: TextStyle(
                                      fontSize: width * 0.042,
                                      color: AppColors.textSecondary
                                          .withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RequestScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(width * 0.032),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.warm.withOpacity(0.15),
                                      AppColors.highlight.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    width * 0.035,
                                  ),
                                  border: Border.all(
                                    color: AppColors.warm.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.warm.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.notifications_rounded,
                                  color: AppColors.primary,
                                  size: width * 0.065,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ===== Summary Card =====
                    _buildSummaryCard(
                      width,
                      height,
                      "Monthly Total Profit",
                      dashboardController
                              .financialSummary["data"]?["monthly"]?["revenue"] ??
                          0,
                      [
                        Color(0xFF27AE60), // success (green)
                        Color(0xFF7F8C8D),
                      ],
                      dashboardController.monthlyPercentage.value,
                      dashboardController.isMonthlyGreater.value,
                    ),
                    _buildSummaryCard(
                      width,
                      height,
                      "Daily Total Profit",
                      dashboardController
                              .financialSummary["data"]?["daily"]?["revenue"] ??
                          0,
                      [AppColors.primary, AppColors.secondary],
                      dashboardController.dailyPercentage.value,
                      dashboardController.isDailyGreater.value,
                    ),

                    SizedBox(height: height * 0.015),

                    // ===== Departments =====
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dashboardController.filteredDepartments.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (width > 600) ? 3 : 2,
                        crossAxisSpacing: width * 0.04,
                        mainAxisSpacing: height * 0.02,
                        childAspectRatio: 0.45,
                      ),
                      itemBuilder: (context, idx) {
                        final dept =
                            dashboardController.filteredDepartments[idx];
                        final deptKey = dept.keys.first;
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 600 + (idx * 100)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: 0.8 + (0.2 * value),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(width * 0.05),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(
                                    width * 0.05,
                                  ),
                                  border: Border.all(
                                    color: (departmentColors['$deptKey'] ??
                                            Colors.grey)
                                        .withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (departmentColors['$deptKey']
                                              as Color)
                                          .withOpacity(0.12),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    width * 0.05,
                                  ),
                                  child: Column(
                                    children: [
                                      // ===== Icon & Name =====
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(width * 0.04),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              (departmentColors['$deptKey']
                                                      as Color)
                                                  .withOpacity(0.08),
                                              (departmentColors['$deptKey']
                                                      as Color)
                                                  .withOpacity(0.03),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width * 0.16,
                                              height: width * 0.16,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    departmentColors['$deptKey']
                                                        as Color,
                                                    (departmentColors['$deptKey']
                                                            as Color)
                                                        .withOpacity(0.7),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      width * 0.04,
                                                    ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        (departmentColors['$deptKey']
                                                                as Color)
                                                            .withOpacity(0.3),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      width * 0.04,
                                                    ),
                                                child: Icon(
                                                  departmentIcons['$deptKey']
                                                      as IconData,
                                                  color: Colors.white,
                                                  size: width * 0.09,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.012),
                                            Text(
                                              deptKey,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color:
                                                    departmentColors['$deptKey']
                                                        as Color,
                                                fontSize: width * 0.042,
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ===== Stats =====
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            width * 0.035,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // Revenue Row
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                      width * 0.02,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (departmentColors['$deptKey']
                                                                  as Color)
                                                              .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            width * 0.02,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.payments_rounded,
                                                      color:
                                                          departmentColors['$deptKey']
                                                              as Color,
                                                      size: width * 0.04,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Daily Revenue',
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            color:
                                                                AppColors
                                                                    .textSecondary,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.2,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          dept['$deptKey']['daily_revenue']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                AppColors
                                                                    .textPrimary,
                                                            fontSize:
                                                                width * 0.035,
                                                            letterSpacing: -0.3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Profit Row
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                      width * 0.02,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.success
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            width * 0.02,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.trending_up_rounded,
                                                      color: AppColors.success,
                                                      size: width * 0.04,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Daily Profit',
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            color:
                                                                AppColors
                                                                    .textSecondary,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.2,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          dept['$deptKey']['daily_profit']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                AppColors
                                                                    .success,
                                                            fontSize:
                                                                width * 0.035,
                                                            letterSpacing: -0.3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.02),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                      width * 0.02,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (departmentColors['$deptKey']
                                                                  as Color)
                                                              .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            width * 0.02,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.payments_rounded,
                                                      color:
                                                          departmentColors['$deptKey']
                                                              as Color,
                                                      size: width * 0.04,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Monthly Revenue',
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            color:
                                                                AppColors
                                                                    .textSecondary,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.2,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          dept['$deptKey']['monthly_revenue']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                AppColors
                                                                    .textPrimary,
                                                            fontSize:
                                                                width * 0.035,
                                                            letterSpacing: -0.3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Profit Row
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                      width * 0.02,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.success
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            width * 0.02,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.trending_up_rounded,
                                                      color: AppColors.success,
                                                      size: width * 0.04,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Profit',
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            color:
                                                                AppColors
                                                                    .textSecondary,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.2,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          dept['$deptKey']['monthly_profit']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                AppColors
                                                                    .success,
                                                            fontSize:
                                                                width * 0.035,
                                                            letterSpacing: -0.3,
                                                          ),
                                                        ),
                                                      ],
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
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
            Obx(() {
              return dashboardController.isLoading.value
                  ? Center(
                    child: Material(
                      color: Colors.white.withAlpha(
                        220,
                      ), // only the container becomes white
                      elevation: 10,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 100,
                        width: 200,
                        alignment: Alignment.center,
                        child: Lottie.asset(
                          "assets/animations/ECG.json",
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                  )
                  : SizedBox();
            }),
          ],
        ),
      );
    });
  }

  // ===== Summary Card (reusable) =====
  Widget _buildSummaryCard(
    double width,
    double height,
    String title,
    int amount,
    List<Color> gradient,

    double profitPercentage,
    bool isProfit,
  ) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        padding: EdgeInsets.all(width * 0.05),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(width * 0.045),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(width * 0.025),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  child: Icon(
                    isProfit
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: isProfit ? Colors.white : Color(0xFFE74C3C),
                    size: width * 0.06,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Text(
              'Rs ${(amount / 1000).toStringAsFixed(1)}k',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.09,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                height: 1,
              ),
            ),
            SizedBox(height: height * 0.012),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.025,
                    vertical: height * 0.006,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        profitPercentage > 0
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: isProfit ? Colors.white : Color(0xFFE74C3C),
                        size: width * 0.04,
                      ),
                      SizedBox(width: width * 0.01),
                      Text(
                        profitPercentage.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.032,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  'vs last period',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: width * 0.032,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
