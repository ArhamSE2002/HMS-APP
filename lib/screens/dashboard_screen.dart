import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import 'package:khaiyal_hospital_finance/controllers/dashboardController.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_colors.dart';
import '../widgets/dashboard_summary_card.dart';
import '../widgets/dashboard_small_stat_card.dart';
import '../widgets/dashboard_department_card.dart';
import '../widgets/dashboard_period_selector.dart';

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

  String selectedPeriod = 'today';
  final List<Map<String, String>> periods = [
    {'key': 'today', 'label': 'Today'},
    {'key': 'this_week', 'label': 'This Week'},
    {'key': 'this_month', 'label': 'This Month'},
  ];

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

  // Fallback colors for departments not in the map
  final List<Color> _fallbackColors = [
    Color(0xFF355070),
    Color(0xFF6D597A),
    Color(0xFFB56576),
    Color(0xFFE56B6F),
    Color(0xFFEAAC8B),
    Color(0xFF2980B9),
    Color(0xFF8E44AD),
    Color(0xFF16A085),
  ];

  // Fallback icons for departments not in the map
  final List<IconData> _fallbackIcons = [
    Icons.local_hospital_rounded,
    Icons.medical_services_rounded,
    Icons.health_and_safety_rounded,
    Icons.medication_rounded,
    Icons.biotech_rounded,
    Icons.monitor_heart_rounded,
  ];

  Color _getDepartmentColor(String deptKey, int index) {
    return departmentColors[deptKey] ??
        _fallbackColors[index % _fallbackColors.length];
  }

  IconData _getDepartmentIcon(String deptKey, int index) {
    return departmentIcons[deptKey] ??
        _fallbackIcons[index % _fallbackIcons.length];
  }

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dashboardController.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      await dashboardController.updateDate(picked);
    }
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
                                    ],
                                  ),
                                  SizedBox(height: height * 0.006),
                                  Text(
                                    authController.userData.isEmpty
                                        ? 'Hospital Owner'
                                        : authController.userData["admin_name"]
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: width * 0.068,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      height: 1.1,
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
                            // ===== Header Actions =====
                            Column(
                              children: [
                                // ===== Logout Button =====
                                GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            width * 0.04,
                                          ),
                                        ),
                                        title: Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        content: Text(
                                          'Are you sure you want to logout?',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                              authController.logout();
                                            },
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                color: AppColors.error,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(width * 0.025),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(
                                        width * 0.03,
                                      ),
                                      border: Border.all(
                                        color: AppColors.error.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.logout_rounded,
                                      color: AppColors.error,
                                      size: width * 0.045,
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // ===== Date Picker Button =====
                                GestureDetector(
                                  onTap: _pickDate,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.025,
                                      vertical: width * 0.015,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withOpacity(0.12),
                                          AppColors.secondary.withOpacity(0.08),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        width * 0.025,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.25,
                                        ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.12,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_rounded,
                                          color: AppColors.primary,
                                          size: width * 0.035,
                                        ),
                                        SizedBox(width: width * 0.015),
                                        Text(
                                          DateFormat('dd MMM').format(
                                            dashboardController
                                                .selectedDate
                                                .value,
                                          ),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: width * 0.028,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ===== Period Selector =====
                    DashboardPeriodSelector(
                      width: width,
                      height: height,
                      animation: _animationController,
                      selectedPeriod: selectedPeriod,
                      periods: periods,
                      onPeriodSelected:
                          (key) => setState(() => selectedPeriod = key),
                    ),

                    if (dashboardController.overallData.isEmpty &&
                        !dashboardController.isLoading.value) ...[
                      SizedBox(height: height * 0.04),
                      Container(
                        height: height * 0.4,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.insert_chart_outlined_rounded,
                              size: width * 0.15,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              "No financial data available for this date.",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // ===== Summary Cards =====
                      DashboardSummaryCard(
                        width: width,
                        height: height,
                        revenueTitle: "Revenue",
                        revenueAmount:
                            dashboardController
                                .overallData["revenue"]?[selectedPeriod] ??
                            0,
                        profitTitle: "Net Profit",
                        profitAmount:
                            dashboardController
                                .overallData["net_profit"]?[selectedPeriod] ??
                            0,
                        gradient: [AppColors.primary, AppColors.secondary],
                        animation: _animationController,
                      ),

                      SizedBox(height: height * 0.015),

                      // ===== Secondary Metrics (Gross Profit, Expense, Purchase) =====
                      Row(
                        children: [
                          Expanded(
                            child: DashboardSmallStatCard(
                              width: width,
                              height: height,
                              title: "Gross Profit",
                              amountVal:
                                  dashboardController
                                      .overallData["gross_profit"]?[selectedPeriod] ??
                                  0,
                              icon: Icons.monetization_on_rounded,
                              color: AppColors.success,
                              animation: _animationController,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: DashboardSmallStatCard(
                              width: width,
                              height: height,
                              title: "Expenses",
                              amountVal:
                                  dashboardController
                                      .overallData["expense"]?[selectedPeriod] ??
                                  0,
                              icon: Icons.money_off_csred_rounded,
                              color: AppColors.error,
                              animation: _animationController,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: DashboardSmallStatCard(
                              width: width,
                              height: height,
                              title: "Purchases",
                              amountVal:
                                  dashboardController
                                      .overallData["purchase"]?[selectedPeriod] ??
                                  0,
                              icon: Icons.shopping_cart_rounded,
                              color: AppColors.warm,
                              animation: _animationController,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.015),

                      // ===== Departments =====
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            dashboardController.filteredDepartments.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (width > 600) ? 3 : 2,
                          crossAxisSpacing: width * 0.03,
                          mainAxisSpacing: height * 0.02,
                          childAspectRatio: 1.8,
                        ),
                        itemBuilder: (context, idx) {
                          final dept =
                              dashboardController.filteredDepartments[idx];
                          final deptKey =
                              dept['dept_id'] as String? ?? 'Department';
                          final deptColor = _getDepartmentColor(deptKey, idx);
                          final deptIcon = _getDepartmentIcon(deptKey, idx);

                          return DashboardDepartmentCard(
                            width: width,
                            height: height,
                            dept: dept,
                            selectedPeriod: selectedPeriod,
                            deptKey: deptKey,
                            deptColor: deptColor,
                            deptIcon: deptIcon,
                            idx: idx,
                          );
                        },
                      ),

                      SizedBox(height: height * 0.03),
                    ],
                  ],
                ),
              ),
            ),
            Obx(() {
              if (!dashboardController.isLoading.value)
                return const SizedBox.shrink();

              return Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            "assets/animations/ECG.json",
                            height: 120,
                            width: 120,
                          ),
                          Text(
                            "Loading Data...",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: width * 0.045,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
