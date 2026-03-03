import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khaiyal_hospital_finance/services/apiService.dart';

class DashboardController extends GetxController {
  // Observable data
  var financialSummary = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  final filteredDepartments = <dynamic>[].obs;

  // Date management
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Services
  final apiService = ApiService();

  @override
  void onInit() async {
    super.onInit();
    await getFinancialSummary();
    _filterDepartments();
  }

  /// Formatted date string for API query
  String get formattedDate =>
      DateFormat('yyyy-MM-dd').format(selectedDate.value);

  /// Updates the selected date and re-fetches data
  Future<void> updateDate(DateTime date) async {
    selectedDate.value = date;
    await refreshData();
  }

  /// Fetches financial summary from API
  /// Returns true if successful, false otherwise
  Future<bool> getFinancialSummary() async {
    isLoading.value = true;

    try {
      final response = await apiService.getRequest(
        "financial/get-summary?date=$formattedDate",
      );

      // The API now returns data directly (not wrapped in "data" key)
      if (response != null && response is Map) {
        financialSummary.value = Map<String, dynamic>.from(response);
        isLoading.value = false;
        return true;
      } else {
        print("Invalid or null response from financial summary API");
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      print("Error fetching financial summary: $e");
      isLoading.value = false;
      return false;
    }
  }

  /// Filters departments that have daily_profit data
  void _filterDepartments() {
    filteredDepartments.clear();

    // Departments are now at the top level of the response
    // Skip known non-department keys
    final nonDepartmentKeys = {
      'hospital_id',
      'date',
      'daily_revenue',
      'daily_net_profit',
      'monthly_revenue',
      'monthly_net_profit',
    };

    financialSummary.forEach((key, value) {
      if (!nonDepartmentKeys.contains(key) &&
          value is Map &&
          value.containsKey("daily_profit")) {
        filteredDepartments.add({key: value});
      }
    });
  }

  /// Refresh data manually (useful for pull-to-refresh)
  Future<void> refreshData() async {
    await getFinancialSummary();
    _filterDepartments();
  }
}
