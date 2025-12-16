// lib/screens/department_detail_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DepartmentDetailScreen extends StatefulWidget {
  final String departmentName;
  const DepartmentDetailScreen({Key? key, required this.departmentName})
    : super(key: key);

  @override
  State<DepartmentDetailScreen> createState() => _DepartmentDetailScreenState();
}

class _DepartmentDetailScreenState extends State<DepartmentDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String selectedPeriod = 'Monthly';

  final Map<String, Color> departmentColors = {
    'Medicine': AppColors.accent,
    'Consultant Fee': AppColors.secondary,
    'Surgery': AppColors.primary,
    'Rooms': AppColors.warm,
    'Labs': AppColors.highlight,
    'OPD': AppColors.success,
    'Pharmacy': AppColors.error,
  };

  final Map<String, IconData> departmentIcons = {
    'Medicine': Icons.medication_rounded,
    'Consultant Fee': Icons.person_outline_rounded,
    'Surgery': Icons.healing_rounded,
    'Rooms': Icons.hotel_rounded,
    'Labs': Icons.science_rounded,
    'OPD': Icons.groups_rounded,
    'Pharmacy': Icons.local_pharmacy_rounded,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, Map<String, String>> getBreakdownData() {
    return {
      'Daily': {
        'revenue': '10,000',
        'expense': '4,000',
        'profit': '6,000',
        'growth': '+8.5%',
      },
      'Monthly': {
        'revenue': '2,50,000',
        'expense': '1,10,000',
        'profit': '1,40,000',
        'growth': '+12.3%',
      },
      'Yearly': {
        'revenue': '30,00,000',
        'expense': '15,00,000',
        'profit': '15,00,000',
        'growth': '+18.7%',
      },
    };
  }

  Color getDepartmentColor() {
    return departmentColors[widget.departmentName] ?? AppColors.primary;
  }

  IconData getDepartmentIcon() {
    return departmentIcons[widget.departmentName] ?? Icons.business_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final color = getDepartmentColor();
    final breakdownData = getBreakdownData();
    final currentData = breakdownData[selectedPeriod]!;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.05),
                    AppColors.background,
                    color.withOpacity(0.03),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(width, height, color),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            _buildHeroCard(width, height, color, currentData),
                            _buildPeriodSelector(width, height),
                            _buildFinancialBreakdown(
                              width,
                              height,
                              color,
                              currentData,
                            ),
                            _buildComparisonSection(
                              width,
                              height,
                              color,
                              breakdownData,
                            ),
                            _buildInsightsSection(width, height, color),
                            SizedBox(height: height * 0.03),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(double width, double height, Color color) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.045,
          vertical: height * 0.02,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(width * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(width * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: color,
                  size: width * 0.06,
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.departmentName,
                    style: TextStyle(
                      fontSize: width * 0.065,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  Text(
                    'Financial Overview',
                    style: TextStyle(
                      fontSize: width * 0.038,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(width * 0.03),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
                ),
                borderRadius: BorderRadius.circular(width * 0.03),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Icon(
                getDepartmentIcon(),
                color: color,
                size: width * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    double width,
    double height,
    Color color,
    Map<String, String> data,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.045,
          vertical: height * 0.015,
        ),
        padding: EdgeInsets.all(width * 0.055),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(width * 0.05),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 28,
              offset: const Offset(0, 14),
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
                  'Total Revenue',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: width * 0.04,
                      ),
                      SizedBox(width: width * 0.01),
                      Text(
                        data['growth']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.033,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Rs ${data['revenue']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.1,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
                height: 1,
              ),
            ),
            SizedBox(height: height * 0.008),
            Text(
              'for $selectedPeriod period',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: width * 0.036,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: height * 0.025),
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    'Expenses',
                    'Rs ${data['expense']}',
                    Icons.arrow_downward_rounded,
                    width,
                  ),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: _buildMiniStat(
                    'Net Profit',
                    'Rs ${data['profit']}',
                    Icons.trending_up_rounded,
                    width,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    IconData icon,
    double width,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.035),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: width * 0.05),
          SizedBox(height: width * 0.02),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: width * 0.032,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: width * 0.01),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.042,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(double width, double height) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.045),
        padding: EdgeInsets.all(width * 0.012),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(width * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children:
              ['Daily', 'Monthly', 'Yearly'].map((period) {
                final isSelected = selectedPeriod == period;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedPeriod = period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    getDepartmentColor(),
                                    getDepartmentColor().withOpacity(0.8),
                                  ],
                                )
                                : null,
                        borderRadius: BorderRadius.circular(width * 0.035),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: getDepartmentColor().withOpacity(
                                      0.35,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : null,
                      ),
                      child: Text(
                        period,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                          fontSize: width * 0.04,
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

  Widget _buildFinancialBreakdown(
    double width,
    double height,
    Color color,
    Map<String, String> data,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(width * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Breakdown',
              style: TextStyle(
                fontSize: width * 0.055,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: height * 0.02),
            _buildBreakdownCard(
              'Total Revenue',
              'Rs ${data['revenue']}',
              Icons.account_balance_wallet_rounded,
              color,
              width,
              height,
              '+15.2% from last period',
            ),
            SizedBox(height: height * 0.015),
            _buildBreakdownCard(
              'Total Expenses',
              'Rs ${data['expense']}',
              Icons.receipt_long_rounded,
              AppColors.error,
              width,
              height,
              '+8.4% from last period',
            ),
            SizedBox(height: height * 0.015),
            _buildBreakdownCard(
              'Net Profit',
              'Rs ${data['profit']}',
              Icons.trending_up_rounded,
              AppColors.success,
              width,
              height,
              '+22.7% from last period',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(
    String title,
    String amount,
    IconData icon,
    Color cardColor,
    double width,
    double height,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: cardColor.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardColor, cardColor.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(width * 0.035),
              boxShadow: [
                BoxShadow(
                  color: cardColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: width * 0.07),
          ),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.038,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: height * 0.006),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: height * 0.004),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: width * 0.03,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection(
    double width,
    double height,
    Color color,
    Map<String, Map<String, String>> allData,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Period Comparison',
              style: TextStyle(
                fontSize: width * 0.055,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(width * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children:
                    allData.entries.map((entry) {
                      final isLast = entry.key == allData.keys.last;
                      return Column(
                        children: [
                          _buildComparisonRow(
                            entry.key,
                            entry.value,
                            color,
                            width,
                          ),
                          if (!isLast)
                            Divider(
                              color: color.withOpacity(0.1),
                              thickness: 1,
                              height: width * 0.08,
                            ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
    String period,
    Map<String, String> data,
    Color color,
    double width,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: width * 0.015,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: color,
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                data['growth']!,
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.025),
          Row(
            children: [
              Expanded(
                child: _buildComparisonStat(
                  'Revenue',
                  'Rs ${data['revenue']}',
                  width,
                ),
              ),
              Expanded(
                child: _buildComparisonStat(
                  'Profit',
                  'Rs ${data['profit']}',
                  width,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonStat(String label, String value, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: width * 0.032,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: width * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(double width, double height, Color color) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: EdgeInsets.all(width * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Insights',
              style: TextStyle(
                fontSize: width * 0.055,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: height * 0.02),
            _buildInsightCard(
              '📈 Strong Performance',
              'Revenue increased by 18.7% this year',
              AppColors.success,
              width,
              height,
            ),
            SizedBox(height: height * 0.015),
            _buildInsightCard(
              '💰 Profit Margin',
              'Maintaining healthy 50% profit margin',
              color,
              width,
              height,
            ),
            SizedBox(height: height * 0.015),
            _buildInsightCard(
              '⚡ Cost Efficiency',
              'Expenses well controlled at 50% of revenue',
              AppColors.highlight,
              width,
              height,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String description,
    Color accentColor,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.012,
            height: width * 0.12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(width * 0.01),
            ),
          ),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: height * 0.006),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
