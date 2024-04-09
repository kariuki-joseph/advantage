import 'package:advantage/bindings/home_page_binding.dart';
import 'package:advantage/bindings/post_ad_binding.dart';
import 'package:advantage/middlewares/auth_middleware.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/finish_profile/finish_profile.dart';
import 'package:advantage/screens/home/home_page.dart';
import 'package:advantage/screens/phone_verification/phone_verification.dart';
import 'package:advantage/screens/pin_login/phone_login.dart';
import 'package:advantage/screens/pin_login/setup_pin.dart';
import 'package:advantage/screens/pin_login/pin_login.dart';
import 'package:advantage/screens/post_ad/post_ad.dart';
import 'package:advantage/screens/register.dart';
import 'package:advantage/screens/splash_screen.dart';
import 'package:advantage/screens/update_ad/update_ad.dart';
import 'package:advantage/screens/verification_success/verification_success.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppPage {
  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const Register(),
    ),
    GetPage(
      name: AppRoutes.verifyPhone,
      page: () => const PhoneVerification(),
    ),
    GetPage(
      name: AppRoutes.verificationSuccess,
      page: () => const VerificationSuccess(),
    ),
    GetPage(
      name: AppRoutes.setupPin,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 800),
      page: () => const SetupPin(),
    ),
    GetPage(
      name: AppRoutes.pinLogin,
      page: () => const PinLogin(),
    ),
    GetPage(
      name: AppRoutes.finishProfile,
      page: () => const FinishProfile(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomePageBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.phoneLogin,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
      page: () => const PhoneLogin(),
    ),
    GetPage(
      name: AppRoutes.postAd,
      page: () => PostAd(),
      transition: Transition.native,
      binding: PostAdBinding(),
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.updateAd,
      page: () => UpdateAd(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 600),
    ),
  ];
}
