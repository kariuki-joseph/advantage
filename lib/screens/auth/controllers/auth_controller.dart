import 'package:advantage/models/user_model.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _isLoading = false.obs;

  // user who is being registered
  final _user = Rxn<UserModel>();

  bool get isLoading => _isLoading.value;

  UserModel? get user => _user.value;

  // register user
  Future<void> registerUser() async {
    _isLoading.value = true;
    try {
      String userId = _firestore.collection('users').doc().id;
      user!.id = userId;
      await _firestore.collection('users').doc(userId).set(user!.toMap());
      Get.offAllNamed(AppPage.home);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // save user details to local storage
  void saveUserDetailsToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user!.id);
    prefs.setString('username', user!.username);
    prefs.setString('email', user!.email);
    prefs.setString('phone', user!.phone);
    prefs.setString('pin', user!.pin);
  }

  // get user details from local storage
  Future<UserModel> getUserDetailsFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
    String? pin = prefs.getString('pin');

    return UserModel(
      id: id,
      username: username,
      email: email,
      phone: phone,
      pin: pin,
    );
  }
}
