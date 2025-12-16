import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'utils/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/request_screen.dart';
import 'screens/history_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MedicalFinanceApp());
}

class MedicalFinanceApp extends StatelessWidget {
  const MedicalFinanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hospital Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/requests': (context) => const RequestScreen(),
        // History needs requests list, simple demonstration route:
        '/history':
            (context) => HistoryScreen(
              allRequests: [
                {
                  'title': 'Surgery Discount',
                  'description':
                      'Patient requests 20% discount on surgery. Valid reason.',
                  'amount': '20%',
                  'status': 'Accepted',
                },
                {
                  'title': 'Lab Fee Waiver',
                  'description': 'Lab fees waiver for returning client.',
                  'amount': 'Rs 500',
                  'status': 'Rejected',
                },
              ],
            ),
      },
    );
  }
}
