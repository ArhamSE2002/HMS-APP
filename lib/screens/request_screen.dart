// lib/screens/request_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/requestController.dart';
import '../utils/app_colors.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with TickerProviderStateMixin {
  // 🔥 IMPORTANT: filter must be reactive
  final RxString filter = 'Pending'.obs;

  late AnimationController _animationController;
  final requestController = Get.put(RequestController());

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.03),
                    AppColors.background,
                    AppColors.primary.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ---------------- HEADER ----------------
                  FadeTransition(
                    opacity: _animationController,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        width * 0.05,
                        height * 0.02,
                        width * 0.05,
                        height * 0.015,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // LEFT TEXT
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requests',
                                style: TextStyle(
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: height * 0.008),
                              Text(
                                'Manage approval requests',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),

                          // NOTIFICATION ICON (REACTIVE)
                          Obx(() {
                            final pendingCount =
                                requestController.allRequests
                                    .where(
                                      (r) =>
                                          r['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'pending',
                                    )
                                    .length;

                            return Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * 0.032),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.accent.withOpacity(0.15),
                                        AppColors.highlight.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      width * 0.035,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notifications_rounded,
                                    color: AppColors.accent,
                                    size: width * 0.065,
                                  ),
                                ),
                                if (pendingCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(width * 0.015),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        pendingCount.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.028,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- STATS CARDS ----------------
                  Obx(() {
                    final pendingCount =
                        requestController.allRequests
                            .where(
                              (r) =>
                                  r['status'].toString().toLowerCase() ==
                                  'pending',
                            )
                            .length;

                    final acceptedCount =
                        requestController.allRequests
                            .where(
                              (r) =>
                                  r['status'].toString().toLowerCase() ==
                                  'accepted',
                            )
                            .length;

                    final rejectedCount =
                        requestController.allRequests
                            .where(
                              (r) =>
                                  r['status'].toString().toLowerCase() ==
                                  'rejected',
                            )
                            .length;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                        vertical: height * 0.02,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Pending',
                              count: pendingCount.toString(),
                              icon: Icons.pending_rounded,
                              color: AppColors.warm,
                              width: width,
                              height: height,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: StatCard(
                              label: 'Accepted',
                              count: acceptedCount.toString(),
                              icon: Icons.check_circle_rounded,
                              color: AppColors.success,
                              width: width,
                              height: height,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: StatCard(
                              label: 'Rejected',
                              count: rejectedCount.toString(),
                              icon: Icons.cancel_rounded,
                              color: AppColors.error,
                              width: width,
                              height: height,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // ---------------- FILTER BUTTONS ----------------
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter by Status',
                          style: TextStyle(
                            fontSize: width * 0.042,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: height * 0.015),

                        // FILTER CHIPS ARE ALSO REACTIVE
                        Obx(() {
                          return Row(
                            children:
                                ['Pending', 'Accepted', 'Rejected'].map((
                                  status,
                                ) {
                                  bool isSelected = filter.value == status;

                                  Color statusColor = AppColors.primary;
                                  if (status == 'Pending')
                                    statusColor = AppColors.textSecondary;
                                  if (status == 'Accepted')
                                    statusColor = AppColors.success;
                                  if (status == 'Rejected')
                                    statusColor = AppColors.error;

                                  return GestureDetector(
                                    onTap: () => filter.value = status,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: EdgeInsets.only(
                                        right: width * 0.03,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.045,
                                        vertical: height * 0.014,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient:
                                            isSelected
                                                ? LinearGradient(
                                                  colors: [
                                                    statusColor,
                                                    statusColor.withOpacity(
                                                      0.8,
                                                    ),
                                                  ],
                                                )
                                                : null,
                                        color:
                                            isSelected
                                                ? null
                                                : AppColors.cardBackground,
                                        borderRadius: BorderRadius.circular(
                                          width * 0.03,
                                        ),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.transparent
                                                  : statusColor.withOpacity(
                                                    0.3,
                                                  ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                          fontSize: width * 0.038,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),

                  // ---------------- REQUEST LIST ----------------
                  Obx(() {
                    List filtered =
                        filter.value == 'All'
                            ? requestController.allRequests
                            : requestController.allRequests
                                .where(
                                  (r) =>
                                      r['status'].toString().toLowerCase() ==
                                      filter.value.toLowerCase(),
                                )
                                .toList();

                    if (filtered.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.1),
                          child: Text(
                            "No requests found",
                            style: TextStyle(
                              fontSize: width * 0.045,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          return _buildRequestCard(filtered[i], width, height);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- REQUEST CARD ----------------
  Widget _buildRequestCard(Map req, double width, double height) {
    final status = (req['status'] as String).capitalizeFirst ?? 'Pending';

    Color statusColor = AppColors.secondary;
    if (status.toLowerCase() == 'accepted') statusColor = AppColors.success;
    if (status.toLowerCase() == 'rejected') statusColor = AppColors.error;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.045),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // CARD HEADER
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.08),
                  statusColor.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.045),
                topRight: Radius.circular(width * 0.045),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.03),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: width * 0.06,
                  ),
                ),
                SizedBox(width: width * 0.035),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req['title'] ?? '',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: height * 0.003),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: width * 0.035,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: width * 0.015),
                          Text(
                            req['date_time'] != null
                                ? req['date_time'].toString().split('T')[0]
                                : '',
                            style: TextStyle(
                              fontSize: width * 0.032,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CARD CONTENT
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req['message'] ?? '',
                  style: TextStyle(
                    fontSize: width * 0.038,
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: height * 0.01),
                Divider(color: statusColor.withOpacity(0.1), thickness: 1),
                SizedBox(height: height * 0.01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // IF PENDING → SHOW ACTION BUTTONS
                    if (status.toLowerCase() == 'pending')
                      Row(
                        children: [
                          // ACCEPT BTN
                          _buildActionButton(
                            Icons.check_rounded,
                            AppColors.success,
                            width,
                            () {
                              int index = requestController.allRequests.indexOf(
                                req,
                              );
                              requestController.updateRequest({
                                "request_id":
                                    requestController.allRequests[index]['id'],
                                "status": "accepted",
                              });
                              requestController.allRequests[index]['status'] =
                                  'accepted';

                              requestController.allRequests.refresh();
                            },
                          ),

                          SizedBox(width: width * 0.025),

                          // REJECT BTN
                          _buildActionButton(
                            Icons.close_rounded,
                            AppColors.error,
                            width,
                            () {
                              int index = requestController.allRequests.indexOf(
                                req,
                              );
                              requestController.updateRequest({
                                "request_id":
                                    requestController.allRequests[index]['id'],
                                "status": "rejected",
                              });
                              requestController.allRequests[index]['status'] =
                                  'rejected';

                              requestController.allRequests.refresh();
                            },
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(width * 0.025),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              status.toLowerCase() == 'accepted'
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: statusColor,
                              size: width * 0.045,
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w800,
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
        ],
      ),
    );
  }

  // ---------------- ACTION BUTTON ----------------
  Widget _buildActionButton(
    IconData icon,
    Color color,
    double width,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(width * 0.02),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(width * 0.025),
        ),
        child: Icon(icon, color: Colors.white, size: width * 0.06),
      ),
    );
  }
}

// ---------------- STAT CARD WIDGET ----------------
class StatCard extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final Color color;
  final double width;
  final double height;

  const StatCard({
    Key? key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.018,
        horizontal: width * 0.03,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
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
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: width * 0.03,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
