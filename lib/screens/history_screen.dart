// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allRequests;

  const HistoryScreen({
    Key? key,
    this.allRequests = const [
      {
        'title': 'Surgery Discount',
        'description': 'Patient requests 20% discount on surgery. Valid reason provided.',
        'amount': '20%',
        'status': 'Accepted',
        'date': '2 days ago',
        'department': 'Surgery',
        'icon': Icons.healing_rounded,
        'color': AppColors.primary,
        'processedBy': 'Dr. Sarah Khan',
      },
      {
        'title': 'Lab Fee Waiver',
        'description': 'Lab fees waiver for returning client with financial difficulty.',
        'amount': 'Rs 500',
        'status': 'Rejected',
        'date': '3 days ago',
        'department': 'Labs',
        'icon': Icons.science_rounded,
        'color': AppColors.highlight,
        'processedBy': 'Dr. Ahmed Ali',
      },
      {
        'title': 'Medicine Subsidy',
        'description': 'Patient requires subsidy on prescribed medicines.',
        'amount': 'Rs 800',
        'status': 'Accepted',
        'date': '5 days ago',
        'department': 'Pharmacy',
        'icon': Icons.local_pharmacy_rounded,
        'color': AppColors.error,
        'processedBy': 'Dr. Sarah Khan',
      },
      {
        'title': 'Room Upgrade',
        'description': 'Upgrade from general to private room for medical reasons.',
        'amount': 'Rs 1,500',
        'status': 'Rejected',
        'date': '1 week ago',
        'department': 'Rooms',
        'icon': Icons.hotel_rounded,
        'color': AppColors.warm,
        'processedBy': 'Admin Team',
      },
      {
        'title': 'Extended Stay',
        'description': 'Patient needs extended hospital stay with reduced rates.',
        'amount': 'Rs 2,000',
        'status': 'Accepted',
        'date': '1 week ago',
        'department': 'Rooms',
        'icon': Icons.hotel_rounded,
        'color': AppColors.warm,
        'processedBy': 'Dr. Ahmed Ali',
      },
      {
        'title': 'Consultation Package',
        'description': 'Multiple consultations required, requesting package discount.',
        'amount': '15%',
        'status': 'Accepted',
        'date': '2 weeks ago',
        'department': 'Consultant',
        'icon': Icons.person_outline_rounded,
        'color': AppColors.secondary,
        'processedBy': 'Dr. Sarah Khan',
      },
    ],
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String filterStatus = 'All';
  String searchQuery = '';

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

  List<Map<String, dynamic>> _getFilteredHistory() {
    var history = widget.allRequests
        .where((r) => r['status'] != 'Pending')
        .toList();

    if (filterStatus != 'All') {
      history = history.where((r) => r['status'] == filterStatus).toList();
    }

    if (searchQuery.isNotEmpty) {
      history = history
          .where((r) =>
              r['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              r['department'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return history;
  }

  int _getAcceptedCount() {
    return widget.allRequests
        .where((r) => r['status'] == 'Accepted')
        .length;
  }

  int _getRejectedCount() {
    return widget.allRequests
        .where((r) => r['status'] == 'Rejected')
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final history = _getFilteredHistory();

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
                    AppColors.primary.withOpacity(0.03),
                    AppColors.background,
                    AppColors.secondary.withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(width, height),
                _buildStatsRow(width, height),
                _buildSearchBar(width, height),
                _buildFilterTabs(width, height),
                Expanded(
                  child: _buildHistoryList(history, width, height),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double width, double height) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          width * 0.05,
          height * 0.02,
          width * 0.05,
          height * 0.015,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: -1.2,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: height * 0.008),
                  Text(
                    'All processed requests',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(width * 0.032),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(width * 0.035),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: width * 0.065,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(double width, double height) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total',
                widget.allRequests.length.toString(),
                Icons.receipt_long_rounded,
                AppColors.primary,
                width,
                height,
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: _buildStatCard(
                'Accepted',
                _getAcceptedCount().toString(),
                Icons.check_circle_rounded,
                AppColors.success,
                width,
                height,
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: _buildStatCard(
                'Rejected',
                _getRejectedCount().toString(),
                Icons.cancel_rounded,
                AppColors.error,
                width,
                height,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String count,
    IconData icon,
    Color color,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.018,
        horizontal: width * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: width * 0.065),
          SizedBox(height: height * 0.008),
          Text(
            count,
            style: TextStyle(
              fontSize: width * 0.065,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: width * 0.03,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double width, double height) {
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
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(width * 0.04),
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => setState(() => searchQuery = value),
          style: TextStyle(
            fontSize: width * 0.04,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Search requests...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.6),
              fontSize: width * 0.04,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: width * 0.06,
            ),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: AppColors.textSecondary,
                      size: width * 0.055,
                    ),
                    onPressed: () => setState(() => searchQuery = ''),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.018,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(double width, double height) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Status',
              style: TextStyle(
                fontSize: width * 0.042,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: height * 0.015),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Accepted', 'Rejected'].map((status) {
                  final isSelected = filterStatus == status;
                  Color statusColor = AppColors.primary;
                  IconData statusIcon = Icons.all_inclusive_rounded;

                  if (status == 'Accepted') {
                    statusColor = AppColors.success;
                    statusIcon = Icons.check_circle_rounded;
                  } else if (status == 'Rejected') {
                    statusColor = AppColors.error;
                    statusIcon = Icons.cancel_rounded;
                  }

                  return GestureDetector(
                    onTap: () => setState(() => filterStatus = status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: width * 0.03),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.045,
                        vertical: height * 0.014,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [statusColor, statusColor.withOpacity(0.8)],
                              )
                            : null,
                        color: isSelected ? null : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(width * 0.03),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : statusColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? statusColor.withOpacity(0.3)
                                : Colors.transparent,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            statusIcon,
                            color: isSelected ? Colors.white : statusColor,
                            size: width * 0.045,
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            status,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: width * 0.038,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    List<Map<String, dynamic>> history,
    double width,
    double height,
  ) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: width * 0.2,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            SizedBox(height: height * 0.02),
            Text(
              'No history found',
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: width * 0.036,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        width * 0.05,
        height * 0.02,
        width * 0.05,
        height * 0.02,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, i) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (i * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _buildHistoryCard(history[i], width, height),
        );
      },
    );
  }

  Widget _buildHistoryCard(
    Map<String, dynamic> req,
    double width,
    double height,
  ) {
    final status = req['status'] as String;
    final isAccepted = status == 'Accepted';
    final statusColor = isAccepted ? AppColors.success : AppColors.error;
    final cardColor = req['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.018),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.045),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Status
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.1),
                  statusColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.043),
                topRight: Radius.circular(width * 0.043),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.025),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(width * 0.025),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isAccepted ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: Colors.white,
                    size: width * 0.055,
                  ),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'Processed ${req['date']}',
                        style: TextStyle(
                          fontSize: width * 0.032,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(width * 0.02),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Icon(
                    req['icon'] as IconData,
                    color: cardColor,
                    size: width * 0.05,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        req['title'],
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Text(
                      req['amount'],
                      style: TextStyle(
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.w900,
                        color: cardColor,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  req['description'],
                  style: TextStyle(
                    fontSize: width * 0.036,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Divider(
                  color: statusColor.withOpacity(0.15),
                  thickness: 1,
                ),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business_rounded,
                          size: width * 0.04,
                          color: cardColor,
                        ),
                        SizedBox(width: width * 0.015),
                        Text(
                          req['department'],
                          style: TextStyle(
                            fontSize: width * 0.035,
                            color: cardColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: width * 0.04,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: width * 0.015),
                        Text(
                          req['processedBy'],
                          style: TextStyle(
                            fontSize: width * 0.032,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}