import 'package:get/get.dart';
import 'package:khaiyal_hospital_finance/services/apiService.dart';

class RequestController extends GetxController {
  var isLoading = false.obs;
  var allRequests = [].obs;
  final apiService = ApiService();
  var isDirty = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (isDirty.value) {
      getRequests();
    }
  }

  Future<dynamic> getRequests() async {
    final response = await apiService.getRequest("request/get_request");
    // print(response);

    allRequests.value = response["data"];
    print(allRequests);
    isDirty.value = false;
  }

  Future<dynamic> updateRequest(Map<String, dynamic> data) async {
    print(data);
    final response = await apiService.patch("request/update-status", data);
    print("Request updated successfully");
    isDirty.value = true;
  }
}
