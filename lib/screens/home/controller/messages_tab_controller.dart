import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MessagesTabController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getMessages() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
