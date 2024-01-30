import 'package:advantage/screens/home/home_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinLoginController extends GetxController {
  final loginPin = [].obs;
  String savedPin = "";
  final isPinWrong = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // get pin saved in localStorage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPin = prefs.getString("pin") ?? "";

    // listen for pin input
    ever(loginPin, (_) {
      if (loginPin.length == 4) {
        if (isPinWrong.value) {
          isPinWrong.value = false;
        }

        if (loginPin.join('') != savedPin) {
          // Incorrect pin. Retry
          isPinWrong.value = true;
          loginPin.clear();
          return;
        }

        // else pin is correct. Proceed to Home
        Get.to(
          () => const HomePage(),
          transition: Transition.leftToRight,
          duration: const Duration(milliseconds: 800),
        );
      }
    });
  }

  // delete last pin character
  void deleteLastPin() {
    if (loginPin.isNotEmpty) {
      loginPin.removeLast();
    }
  }
}
