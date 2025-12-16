import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khaiyal_hospital_finance/screens/auth/login_screen.dart';
import 'package:khaiyal_hospital_finance/screens/dashboard_screen.dart';

class AuthController extends GetxController {
  final storage = FlutterSecureStorage();
  var isLoading = false.obs;
  var userData = {}.obs;

  static const String baseUrl = "http://192.168.1.40:3000/";

  // ================================================================
  // CHECK AUTH
  // ================================================================
  Future<void> checkAuth() async {
    final token = await storage.read(key: "token");
    print("Token: $token");

    if (token == null) {
      print("No Token Found in Storage");
      Get.offAll(() => LoginScreen());
      return;
    }

    // Token exists → go to dashboard
    Get.offAll(() => DashboardScreen());

    // If profile already loaded, no need to fetch again
    if (userData.isNotEmpty) return;

    await fetchProfile(token);
  }

  // ================================================================
  // LOGIN
  // ================================================================
  Future<dynamic> login(String endpoint, String hID, String password) async {
    isLoading.value = true;

    var userInfo = {"hospital_id": hID, "password": password};

    try {
      final url = Uri.parse("$baseUrl$endpoint");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userInfo),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        isLoading.value = false;
        Get.snackbar("Login Unsuccessful", "Invalid credentials");
        return null;
      }

      final json = jsonDecode(response.body);
      final token = json["access_token"];

      // Save token
      await storage.write(key: "token", value: token);
      print("Token saved successfully: $token");

      isLoading.value = false;

      // Navigate to dashboard
      Get.offAll(() => DashboardScreen());

      // Fetch profile after login
      await fetchProfile(token);
    } catch (e) {
      isLoading.value = false;
      print("Login Error: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }

  // ================================================================
  // FETCH USER PROFILE
  // ================================================================
  Future<void> fetchProfile(String token) async {
    try {
      final profileUrl = Uri.parse("${baseUrl}accounts/profile");

      final response = await http.get(
        profileUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        userData.value = jsonDecode(response.body);
        print("Profile Loaded: $userData");
      } else if (response.statusCode == 401) {
        print("Token Expired");
        await logout();
      } else {
        print("Profile Fetch Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Profile Error: $e");
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================
  Future<void> logout() async {
    await storage.delete(key: "token");
    userData.clear();
    Get.offAll(() => LoginScreen());
  }
}
