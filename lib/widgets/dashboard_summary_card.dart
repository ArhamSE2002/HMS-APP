import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_formatters.dart';

class DashboardSummaryCard extends StatelessWidget {
  final double width;
  final double height;
  final String revenueTitle;
  final dynamic revenueAmount;
  final String profitTitle;
  final dynamic profitAmount;
  final List<Color> gradient;
  final Animation<double> animation;

  const DashboardSummaryCard({
    Key? key,
    required this.width,
    required this.height,
    required this.revenueTitle,
    required this.revenueAmount,
    required this.profitTitle,
    required this.profitAmount,
    required this.gradient,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final revenue = (revenueAmount is num) ? revenueAmount.toDouble() : 0.0;
    final profit = (profitAmount is num) ? profitAmount.toDouble() : 0.0;

    final bool isPositive = profit >= 0;
    final Color profitColor =
        isPositive ? const Color(0xFF4ADE80) : const Color(0xFFF87171);
    final IconData profitIcon =
        isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return FadeTransition(
      opacity: animation,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.008),
        padding: EdgeInsets.all(width * 0.035),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(width * 0.035),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Decorative Icon
            Positioned(
              right: -width * 0.05,
              bottom: -width * 0.05,
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: width * 0.35,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            // Decorative Circle
            Positioned(
              right: width * 0.1,
              top: -width * 0.1,
              child: Container(
                width: width * 0.25,
                height: width * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Column(
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
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(width * 0.018),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(width * 0.02),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: width * 0.045,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.008),
                Text(
                  'Rs ${AppFormatters.formatAmount(revenue)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    height: 1,
                  ),
                ),
                SizedBox(height: height * 0.012),
                // Profit section
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.025,
                    vertical: height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(profitIcon, color: profitColor, size: width * 0.042),
                      SizedBox(width: width * 0.015),
                      Text(
                        '$profitTitle: ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: width * 0.028,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Rs ${AppFormatters.formatAmount(profit)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.038,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
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
    );
  }
}
