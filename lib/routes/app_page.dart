import 'package:advantage/screens/phone_verification/phone_verification.dart';
import 'package:advantage/screens/register.dart';
import 'package:advantage/screens/splash_screen.dart';
import 'package:advantage/screens/verification_success/verification_success.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPage {
  static const String splash = "/splash";
  static const String register = "/register";
  static const String verifyPhone = "/verify-phone";
  static const String verificationSuccess = "/verification-success";
  static const String setupPin = "/setup-pin";
  static const String confirmPin = "/confirm-pin";
  static const String finishProfile = "/finish-profile";
  static const String home = "/home";

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: register, page: () => const Register()),
    GetPage(name: verifyPhone, page: () => const PhoneVerification()),
    GetPage(name: verificationSuccess, page: () => const VerificationSuccess()),
    GetPage(name: setupPin, page: () => const SplashScreen()),
    GetPage(name: confirmPin, page: () => const SplashScreen()),
    GetPage(name: finishProfile, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const SplashScreen()),
  ];
}
