import 'package:get/get.dart';
import 'package:khaiyal_hospital_finance/controllers/authController.dart';
import 'package:khaiyal_hospital_finance/services/apiService.dart';

class DashboardController extends GetxController {
  // Observable data
  var financialSummary = {}.obs;
  var isLoading = false.obs;
  final filteredDepartments = <dynamic>[].obs;

  // Trend indicators
  final isMonthlyGreater = true.obs;
  final isDailyGreater = true.obs;
  final RxDouble monthlyPercentage = 0.0.obs;
  final RxDouble dailyPercentage = 0.0.obs;

  // Services
  final apiService = ApiService();
  final authController = Get.find<AuthController>();

  @override
  void onInit() async {
    super.onInit();
    await _fetchAndProcess();
    _filterDepartments();
  }

  /// Fetches financial summary and processes trend calculations
  Future<void> _fetchAndProcess() async {
    final success = await getFinancialSummary();
    
    // Only calculate trends if API call was successful
    if (success) {
      await getPreviousValues();
    } else {
      print("API call failed, skipping trend calculation");
    }
  }

  /// Fetches financial summary from API
  /// Returns true if successful, false otherwise
  Future<bool> getFinancialSummary() async {
    isLoading.value = true;
    
    try {
      final response = await apiService.getRequest("financial/get-summary");
      
      // Validate response
      if (response != null && response is Map && response["data"] != null) {
        financialSummary.value = response;
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
    filteredDepartments.clear(); // Clear existing data
    
    var data = financialSummary["data"];
    if (data != null && data is Map) {
      data.forEach((key, value) {
        if (value is Map && value.containsKey("daily_profit")) {
          filteredDepartments.add({"$key": value});
        }
      });
    }
  }

  /// Calculates percentage changes and updates trend indicators
  Future<void> getPreviousValues() async {
    // Safety check: Ensure financial summary is loaded
    if (financialSummary.isEmpty || financialSummary["data"] == null) {
      print("Financial summary not loaded, cannot calculate trends");
      return;
    }

    // Get current values from API
    final currMonthly = _parseRevenue("monthly");
    final currDaily = _parseRevenue("daily");

    // Validate current values
    if (currMonthly == null || currDaily == null) {
      print("Failed to parse current revenue values");
      return;
    }

    // Read stored values
    final prevMonthlyStr =
        await authController.storage.read(key: "previous_monthly_revenue") ?? "";
    final prevDailyStr =
        await authController.storage.read(key: "previous_daily_revenue") ?? "";
    final prevMonthlyPercStr =
        await authController.storage.read(key: "previous_monthly_percent") ?? "";
    final prevDailyPercStr =
        await authController.storage.read(key: "previous_daily_percent") ?? "";

    print("Previous Monthly: $prevMonthlyStr | Current Monthly: $currMonthly");
    print("Previous Daily: $prevDailyStr | Current Daily: $currDaily");

    // Handle first-time launch or after logout/token expiry (no stored data)
    if (prevMonthlyStr.isEmpty || prevDailyStr.isEmpty) {
      print("First time initialization - saving current values");
      await _saveCurrentValues(currMonthly, currDaily, 0.0, 0.0);
      
      monthlyPercentage.value = 0.0;
      dailyPercentage.value = 0.0;
      isMonthlyGreater.value = true;
      isDailyGreater.value = true;
      return;
    }

    // Parse stored values
    final prevMonthly = double.tryParse(prevMonthlyStr) ?? 0.0;
    final prevDaily = double.tryParse(prevDailyStr) ?? 0.0;
    final prevMonthlyPerc = double.tryParse(prevMonthlyPercStr) ?? 0.0;
    final prevDailyPerc = double.tryParse(prevDailyPercStr) ?? 0.0;

    // Calculate monthly trend
    if (prevMonthly != currMonthly) {
      // Value changed - calculate new percentage
      if (prevMonthly != 0) {
        monthlyPercentage.value = double.parse(
          ((currMonthly - prevMonthly) / prevMonthly * 100).toStringAsFixed(1),
        );
        isMonthlyGreater.value = monthlyPercentage.value >= 0;
      } else {
        // Previous value was 0, can't calculate percentage
        monthlyPercentage.value = 0.0;
        isMonthlyGreater.value = true;
      }
    } else {
      // Value unchanged - reuse previous percentage (stale data from API)
      monthlyPercentage.value = prevMonthlyPerc;
      isMonthlyGreater.value = monthlyPercentage.value >= 0;
    }

    // Calculate daily trend
    if (prevDaily != currDaily) {
      // Value changed - calculate new percentage
      if (prevDaily != 0) {
        dailyPercentage.value = double.parse(
          ((currDaily - prevDaily) / prevDaily * 100).toStringAsFixed(1),
        );
        isDailyGreater.value = dailyPercentage.value >= 0;
      } else {
        // Previous value was 0, can't calculate percentage
        dailyPercentage.value = 0.0;
        isDailyGreater.value = true;
      }
    } else {
      // Value unchanged - reuse previous percentage (stale data from API)
      dailyPercentage.value = prevDailyPerc;
      isDailyGreater.value = dailyPercentage.value >= 0;
    }

    // Save current values for next comparison
    await _saveCurrentValues(
      currMonthly,
      currDaily,
      monthlyPercentage.value,
      dailyPercentage.value,
    );
  }

  /// Parses revenue value from financial summary
  /// Returns null if parsing fails
  double? _parseRevenue(String period) {
    try {
      final revenueValue = financialSummary["data"]?[period]?["revenue"];
      if (revenueValue == null) {
        print("Revenue value for $period is null");
        return null;
      }
      return double.tryParse(revenueValue.toString());
    } catch (e) {
      print("Error parsing $period revenue: $e");
      return null;
    }
  }

  /// Saves current values to secure storage
  Future<void> _saveCurrentValues(
    double currMonthly,
    double currDaily,
    double monthlyPerc,
    double dailyPerc,
  ) async {
    try {
      await authController.storage.write(
        key: "previous_monthly_revenue",
        value: currMonthly.toString(),
      );
      await authController.storage.write(
        key: "previous_daily_revenue",
        value: currDaily.toString(),
      );
      await authController.storage.write(
        key: "previous_monthly_percent",
        value: monthlyPerc.toString(),
      );
      await authController.storage.write(
        key: "previous_daily_percent",
        value: dailyPerc.toString(),
      );
      print("Successfully saved current values to storage");
    } catch (e) {
      print("Error saving values to storage: $e");
    }
  }

  /// Refresh data manually (useful for pull-to-refresh)
  Future<void> refreshData() async {
    await _fetchAndProcess();
    _filterDepartments();
  }
}