import 'package:advantage/models/user_model.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class PinController extends GetxController {
  final pin = [].obs;
  String pin1 = ""; // first pin
  final AuthController authController = Get.find<AuthController>();
  UserModel? loggedInUser;
  final message = "Setup your PIN".obs;
  final hasError = false.obs;
  bool isRepeat = false;

  @override
  void onInit() {
    loggedInUser = authController.user.value;
    super.onInit();
    // listen to repeat pin changes and check if they are correct
    ever(pin, (_) async {
      if (pin.length == 4) {
        if (!isRepeat) {
          // save first pin
          pin1 = pin.join('');
          // wait for 200ms then clear pin
          await Future.delayed(const Duration(milliseconds: 200));
          pin.clear();
          isRepeat = true;
          // update message
          message.value = "Repeat PIN";
          return;
        }

        // check if pin and repeat pin are the same
        if (pin1.toString() != pin.join("")) {
          message.value = "PINs do not match";
          hasError.value = true;
          // wait for 1 second then clear pin
          await Future.delayed(const Duration(milliseconds: 2000));
          pin.clear();
          message.value = "Setup your PIN";
          hasError.value = false;
          isRepeat = false;
          return;
        }

        // update pin to authController
        authController.user.update((val) {
          val!.pin = pin.join('');
        });

        // save pin to local storage
        await authController.saveUserDetailsToSharedPrefs();

        // update to firebase
        await authController.updateUserToFirebase();

        // move to home screen
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  // delete a pin entry
  void deleteLastPin() {
    if (pin.isNotEmpty) {
      pin.removeLast();
    }
  }

  // delete last repeat pin
  void deleteLastpin() {
    if (pin.isNotEmpty) {
      pin.removeLast();
    }
  }
}
