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

  static const String baseUrl = "http://192.168.1.7:3000/";

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

    // Load profile from local storage
    await _loadProfileFromStorage();

    // Token exists → go to dashboard
    Get.offAll(() => DashboardScreen());
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
      final profile = json["profile"];

      // Save token
      await storage.write(key: "token", value: token);
      print("Token saved successfully: $token");

      // Save profile to local storage
      if (profile != null) {
        await _saveProfileToStorage(profile);
        userData.value = profile;
        print("Profile saved: $userData");
      }

      isLoading.value = false;

      // Navigate to dashboard
      Get.offAll(() => DashboardScreen());
    } catch (e) {
      isLoading.value = false;
      print("Login Error: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }

  // ================================================================
  // SAVE PROFILE TO LOCAL STORAGE
  // ================================================================
  Future<void> _saveProfileToStorage(Map<String, dynamic> profile) async {
    try {
      await storage.write(key: "profile", value: jsonEncode(profile));
      print("Profile saved to storage");
    } catch (e) {
      print("Error saving profile: $e");
    }
  }

  // ================================================================
  // LOAD PROFILE FROM LOCAL STORAGE
  // ================================================================
  Future<void> _loadProfileFromStorage() async {
    try {
      final profileStr = await storage.read(key: "profile");
      if (profileStr != null) {
        userData.value = jsonDecode(profileStr);
        print("Profile loaded from storage: $userData");
      } else {
        print("No profile found in storage");
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================
  Future<void> logout() async {
    await storage.delete(key: "token");
    await storage.delete(key: "profile");
    userData.clear();
    Get.offAll(() => LoginScreen());
  }
}
