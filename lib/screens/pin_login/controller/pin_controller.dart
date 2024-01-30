import 'package:advantage/routes/app_page.dart';
import 'package:advantage/screens/pin_login/confirm_pin.dart';
import 'package:advantage/screens/pin_login/setup_pin.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinController extends GetxController {
  final pin = [].obs;
  final repeatPin = [].obs;

  @override
  void onInit() {
    super.onInit();
    // listen to pin changes and navigate to confirm pin screen
    ever(pin, (_) {
      if (pin.length == 4) {
        // move to confirm pin activity
        Get.to(
          () => const ConfirmPin(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 800),
        );
      }
    });

    // listen to repeat pin changes and check if they are correct
    ever(repeatPin, (_) {
      if (repeatPin.length == 4) {
        // check if pin and repeat pin are the same
        if (pin.toString() == repeatPin.toString()) {
          // save pin to local storage
          savePinToSharedPrefs();
          // move to home screen
          Get.offAllNamed(AppPage.home);
        } else {
          // show error message
          showErrorToast("PINs did not match");
          // clear repeat pin
          pin.clear();
          repeatPin.clear();

          Get.to(
            () => const SetupPin(),
            transition: Transition.leftToRight,
            duration: const Duration(milliseconds: 800),
          );
        }
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
  void deleteLastRepeatPin() {
    if (repeatPin.isNotEmpty) {
      repeatPin.removeLast();
    }
  }

  // save pin to local storage
  Future<void> savePinToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pin', pin.join(''));
  }

  // get pin from local storage
  Future<String?> getPinFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin');
  }
}
