import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_formatters.dart';

class DashboardSmallStatCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final dynamic amountVal;
  final IconData icon;
  final Color color;
  final Animation<double> animation;

  const DashboardSmallStatCard({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.amountVal,
    required this.icon,
    required this.color,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amount = (amountVal is num) ? amountVal.toDouble() : 0.0;
    return FadeTransition(
      opacity: animation,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.012,
          horizontal: width * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(width * 0.025),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.015),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: width * 0.035),
            ),
            SizedBox(height: height * 0.008),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: width * 0.024,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * 0.003),
            Text(
              AppFormatters.formatAmount(amount),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: width * 0.032,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
