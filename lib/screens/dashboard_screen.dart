import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import 'package:khaiyal_hospital_finance/controllers/dashboardController.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_colors.dart';

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
                                      horizontal: width * 0.035,
                                      vertical: width * 0.025,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withOpacity(0.12),
                                          AppColors.secondary.withOpacity(0.08),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        width * 0.035,
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
                                          size: width * 0.045,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        Text(
                                          DateFormat('dd MMM').format(
                                            dashboardController
                                                .selectedDate
                                                .value,
                                          ),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: width * 0.033,
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

                    // ===== Summary Cards =====
                    _buildSummaryCard(
                      width,
                      height,
                      "Monthly Revenue",
                      dashboardController.financialSummary["monthly_revenue"] ??
                          0,
                      "Monthly Net Profit",
                      dashboardController
                              .financialSummary["monthly_net_profit"] ??
                          0,
                      [Color(0xFF27AE60), Color(0xFF7F8C8D)],
                    ),
                    _buildSummaryCard(
                      width,
                      height,
                      "Daily Revenue",
                      dashboardController.financialSummary["daily_revenue"] ??
                          0,
                      "Daily Net Profit",
                      dashboardController
                              .financialSummary["daily_net_profit"] ??
                          0,
                      [AppColors.primary, AppColors.secondary],
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
                        final deptColor = _getDepartmentColor(deptKey, idx);
                        final deptIcon = _getDepartmentIcon(deptKey, idx);

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
                                    color: deptColor.withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: deptColor.withOpacity(0.12),
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
                                              deptColor.withOpacity(0.08),
                                              deptColor.withOpacity(0.03),
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
                                                    deptColor,
                                                    deptColor.withOpacity(0.7),
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
                                                    color: deptColor
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
                                                  deptIcon,
                                                  color: Colors.white,
                                                  size: width * 0.09,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.012),
                                            Text(
                                              _formatDeptName(deptKey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: deptColor,
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
                                              // Daily Revenue Row
                                              _buildDeptStatRow(
                                                width,
                                                height,
                                                'Daily Revenue',
                                                dept[deptKey]['daily_revenue']
                                                    .toString(),
                                                Icons.payments_rounded,
                                                deptColor,
                                                AppColors.textPrimary,
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Daily Profit Row
                                              _buildDeptStatRow(
                                                width,
                                                height,
                                                'Daily Profit',
                                                dept[deptKey]['daily_profit']
                                                    .toString(),
                                                Icons.trending_up_rounded,
                                                AppColors.success,
                                                AppColors.success,
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Monthly Revenue Row
                                              _buildDeptStatRow(
                                                width,
                                                height,
                                                'Monthly Revenue',
                                                dept[deptKey]['monthly_revenue']
                                                    .toString(),
                                                Icons.payments_rounded,
                                                deptColor,
                                                AppColors.textPrimary,
                                              ),
                                              SizedBox(height: height * 0.02),

                                              // Monthly Profit Row
                                              _buildDeptStatRow(
                                                width,
                                                height,
                                                'Monthly Profit',
                                                dept[deptKey]['monthly_profit']
                                                    .toString(),
                                                Icons.trending_up_rounded,
                                                AppColors.success,
                                                AppColors.success,
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

  /// Formats department key to a display name (e.g., "patient_visit" -> "Patient Visit")
  String _formatDeptName(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Reusable department stat row widget
  Widget _buildDeptStatRow(
    double width,
    double height,
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color valueColor,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(width * 0.02),
          ),
          child: Icon(icon, color: iconColor, size: width * 0.04),
        ),
        SizedBox(width: width * 0.025),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: width * 0.03,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  fontSize: width * 0.035,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===== Summary Card (reusable) =====
  Widget _buildSummaryCard(
    double width,
    double height,
    String revenueTitle,
    dynamic revenueAmount,
    String profitTitle,
    dynamic profitAmount,
    List<Color> gradient,
  ) {
    final revenue = (revenueAmount is num) ? revenueAmount.toDouble() : 0.0;
    final profit = (profitAmount is num) ? profitAmount.toDouble() : 0.0;

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
            // Revenue section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  revenueTitle,
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
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: width * 0.06,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Rs ${_formatAmount(revenue)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.09,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                height: 1,
              ),
            ),
            SizedBox(height: height * 0.018),
            // Profit section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.035,
                vertical: height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(width * 0.025),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: width * 0.045,
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    '$profitTitle: ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: width * 0.032,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Rs ${_formatAmount(profit)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats amount for display (e.g., 160000 -> "160.0k")
  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }
}
