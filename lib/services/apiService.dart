import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khaiyal_hospital_finance/controllers/authController.dart';

class ApiService {
  final authController = Get.find<AuthController>();
  final storage = FlutterSecureStorage();
  static const String baseUrl = 'http://192.168.1.40:3000/';
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
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      log("Token Expired");
      await authController.logout();
    } else {
      log("Error Fetching Data: ${response.statusCode}");
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    await getToken();
    final url = "$baseUrl$endpoint";
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      log("Token Expired");
      await authController.logout();
    } else {
      print("Error:${response.statusCode} ${response.body}");
      return null;
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    await getToken();
    final url = "$baseUrl$endpoint";
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      log("Token Expired");
      await authController.logout();
    } else {
      print("Error:${response.statusCode} ${response.body}");
      return null;
    }
  }
}
