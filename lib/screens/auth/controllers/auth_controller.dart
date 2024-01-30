import 'package:advantage/models/user_model.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _isLoading = false.obs;
  final pin = ''.obs;
  final repeatPin = ''.obs;

  final phone = ''.obs;

  // user who is being registered
  final _user = Rx<UserModel>(UserModel());

  bool get isLoading => _isLoading.value;

  UserModel get user => _user.value;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  // save user details to local storage
  Future<void> saveUserDetailsToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.id);
    prefs.setString('username', user.username);
    prefs.setString('email', user.email);
    prefs.setString('phone', user.phone);
    prefs.setString('pin', user.pin);
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

  // save details and move to create pin screen
  Future<void> registerUser() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    _user.update((val) {
      val!.username = usernameController.text;
      val.email = emailController.text;
      val.phone = phoneController.text;
      val.pin = pin.value;
    });

    _isLoading.value = true;
    try {
      // check if a simmilar user has been registered before
      if (await _checkIfUserAlreadyRegistered(user.phone, user.email)) {
        showErrorToast("User with this phone number or email already exists");
        return;
      }
      // save user details to firebase
      await _firestore.collection('users').doc(user.phone).set(user.toMap());

      // save user info to local storage
      await saveUserDetailsToSharedPrefs();

      showSuccessToast("Account created successfully");
      // move to create pin screen
      Get.toNamed(AppPage.setupPin);
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

  Future<bool> _checkIfUserAlreadyRegistered(String phone, String email) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final List<DocumentSnapshot<Map<String, dynamic>>> documents = result.docs;
    if (documents.isNotEmpty) {
      return true;
    }
    return false;
  }
}
