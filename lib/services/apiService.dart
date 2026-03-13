import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khaiyal_hospital_finance/controllers/authController.dart';

class ApiService {
  final authController = Get.find<AuthController>();
  final storage = FlutterSecureStorage();
  static const String baseUrl = 'http://192.168.1.7:3000/';
  String? token;

  Future<String?> getToken() async {
    if (token != null) return token!;
    token = await storage.read(key: "token");
    return token;
  }

  Future<dynamic> getRequest(String endpoint) async {
    await getToken();
    final url = Uri.parse("$baseUrl$endpoint");
    log("Fetching $url");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        log("Token Expired or Unauthorized");
        Get.snackbar("Session Expired", "Please login again to continue.");
        await Get.find<AuthController>().logout();
        return null;
      } else {
        log("Error Fetching Data: ${response.statusCode} - ${response.body}");
        try {
          return jsonDecode(response.body);
        } catch (_) {
          return null;
        }
      }
    } catch (e) {
      log("HTTP Exception: $e");
      return null;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    await getToken();
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        log("Token Expired or Unauthorized");
        Get.snackbar("Session Expired", "Please login again to continue.");
        await Get.find<AuthController>().logout();
        return null;
      } else {
        log("Error Posting Data: ${response.statusCode} - ${response.body}");
        try {
          return jsonDecode(response.body);
        } catch (_) {
          return null;
        }
      }
    } catch (e) {
      log("HTTP Exception: $e");
      return null;
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    await getToken();
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.patch(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        log("Token Expired or Unauthorized");
        Get.snackbar("Session Expired", "Please login again to continue.");
        await Get.find<AuthController>().logout();
        return null;
      } else {
        log("Error Patching Data: ${response.statusCode} - ${response.body}");
        try {
          return jsonDecode(response.body);
        } catch (_) {
          return null;
        }
      }
    } catch (e) {
      log("HTTP Exception: $e");
      return null;
    }
  }
}
