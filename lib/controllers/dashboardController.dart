import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khaiyal_hospital_finance/services/apiService.dart';

class DashboardController extends GetxController {
  // Observable data
  var overallData = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  final filteredDepartments = <dynamic>[].obs;
  var selectedPeriod = 'today'.obs;

  // Date management
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Services
  final apiService = ApiService();

  @override
  void onInit() async {
    super.onInit();
    await getFinancialSummary();
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

      // The API now returns nested data
      if (response != null && response is Map) {
        if (response['success'] == false) {
          overallData.clear();
          filteredDepartments.clear();
        } else {
          if (response.containsKey('overall')) {
            overallData.value = Map<String, dynamic>.from(response['overall']);
          } else {
            overallData.clear();
          }
          if (response.containsKey('department_breakdown')) {
            filteredDepartments.value = List<dynamic>.from(
              response['department_breakdown'],
            );
          } else {
            filteredDepartments.clear();
          }
        }
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

  /// Refresh data manually (useful for pull-to-refresh)
  Future<void> refreshData() async {
    await getFinancialSummary();
  }
}
