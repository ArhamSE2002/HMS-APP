import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DashboardPeriodSelector extends StatelessWidget {
  final double width;
  final double height;
  final Animation<double> animation;
  final String selectedPeriod;
  final List<Map<String, String>> periods;
  final Function(String) onPeriodSelected;

  const DashboardPeriodSelector({
    Key? key,
    required this.width,
    required this.height,
    required this.animation,
    required this.selectedPeriod,
    required this.periods,
    required this.onPeriodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.008),
        padding: EdgeInsets.all(width * 0.012),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(width * 0.03),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children:
              periods.map((period) {
                final isSelected = selectedPeriod == period['key'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onPeriodSelected(period['key']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(vertical: height * 0.012),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                )
                                : null,
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                      child: Text(
                        period['label']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                          fontSize: width * 0.028,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
