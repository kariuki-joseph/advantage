import 'package:advantage/constants/app_color.dart';
import 'package:advantage/firebase_options.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/splash_screen.dart';
import 'package:advantage/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialRoute: AppPage.splash,
      getPages: AppPage.routes,
    );
  }
}
