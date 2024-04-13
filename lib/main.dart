import 'package:advantage/firebase_options.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/location_controller.dart';
import 'package:advantage/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // add authController to getx dependency injection
  Get.put(AuthController());
  Get.put(LocationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // set app theme
  final MaterialTheme materialTheme = const MaterialTheme(TextTheme());

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADvantage',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      initialRoute: AppRoutes.splash,
      getPages: AppPage.routes,
    );
  }
}
