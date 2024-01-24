import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      Get.offAllNamed(AppPage.home);
      return;
      // // check if user has already created an account, login if true
      // UserModel savedUser =
      //     await authController.getUserDetailsFromSharedPrefs();

      // if (savedUser.id == "") {
      //   // go to register page
      //   Get.offAllNamed(AppPage.register);
      //   return;
      // }

      // // already registered, go to pin login page
      // Get.offAllNamed(AppPage.pinLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo.png", fit: BoxFit.contain),
            const SizedBox(height: 20),
            const Text("AdVantage",
                style: TextStyle(fontSize: 42, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
