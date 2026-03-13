import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_formatters.dart';

class DashboardDepartmentCard extends StatelessWidget {
  final double width;
  final double height;
  final Map<String, dynamic> dept;
  final String selectedPeriod;
  final String deptKey;
  final Color deptColor;
  final IconData deptIcon;
  final int idx;

  const DashboardDepartmentCard({
    Key? key,
    required this.width,
    required this.height,
    required this.dept,
    required this.selectedPeriod,
    required this.deptKey,
    required this.deptColor,
    required this.deptIcon,
    required this.idx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          borderRadius: BorderRadius.circular(width * 0.04),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(width * 0.04),
              border: Border.all(color: deptColor.withOpacity(0.15), width: 1),
              boxShadow: [
                BoxShadow(
                  color: deptColor.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // ===== Left Side: Icon & Title =====
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.1,
                        height: width * 0.08,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [deptColor, deptColor.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(width * 0.025),
                        ),
                        child: Icon(
                          deptIcon,
                          color: Colors.white,
                          size: width * 0.04,
                        ),
                      ),
                      SizedBox(height: height * 0.008),
                      Text(
                        AppFormatters.formatDeptName(deptKey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: deptColor,
                          fontSize: width * 0.03,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  height: double.infinity,
                  color: deptColor.withOpacity(0.15),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                ),

                // ===== Right Side: Stats =====
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDeptStatRowMini(
                        width,
                        'Rev: ',
                        dept['revenue']?[selectedPeriod]?.toString() ?? '0',
                        AppColors.textSecondary,
                        Icons.payments_rounded,
                      ),
                      SizedBox(height: height * 0.008),
                      Builder(
                        builder: (context) {
                          var rawProfit =
                              dept['net_profit']?[selectedPeriod] ?? 0;
                          final deptProfit =
                              (rawProfit is num)
                                  ? rawProfit.toDouble()
                                  : double.tryParse(rawProfit.toString()) ??
                                      0.0;
                          final bool isPositiveDept = deptProfit >= 0;
                          final Color deptProfitColor =
                              isPositiveDept
                                  ? AppColors.success
                                  : AppColors.error;
                          final IconData deptProfitIcon =
                              isPositiveDept
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded;

                          return _buildDeptStatRowMini(
                            width,
                            'Prof: ',
                            rawProfit.toString(),
                            deptProfitColor,
                            deptProfitIcon,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeptStatRowMini(
    double width,
    String label,
    String value,
    Color iconColor,
    IconData icon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: width * 0.035),
        SizedBox(width: width * 0.01),
        Text(
          label,
          style: TextStyle(
            fontSize: width * 0.026,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: width * 0.03,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
