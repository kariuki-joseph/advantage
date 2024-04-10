import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:advantage/models/user_model.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.put(AuthController());
  UserModel savedUser = Get.find<AuthController>().user.value;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      // check if user has already created an account, login if true
      if (savedUser.pin == "" || savedUser.phone == "") {
        // go to register page
        Get.offAllNamed(AppRoutes.register);
        return;
      }

      // already registered, go to pin login page
      Get.offAllNamed(AppRoutes.pinLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo.png", fit: BoxFit.contain),
            const SizedBox(height: 20),
            Text(
              "ADvantage",
              style: TextStyle(
                fontSize: 42,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
