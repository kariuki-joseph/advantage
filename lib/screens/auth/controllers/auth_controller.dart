import 'package:advantage/models/user_model.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/utils/toast_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  String phonePrefix = "+254";

  // user who is being registered
  final user = Rx<UserModel>(UserModel());

  // add a computed property to check login status
  bool get isLoggedIn => user.value.id.isNotEmpty;

  @override
  void onInit() async {
    // get user details from local storage
    UserModel? savedUser = await getUserDetailsFromSharedPrefs();
    if (savedUser != null) {
      user.value = savedUser;
    }
    super.onInit();
  }

  // save user details to local storage
  Future<void> saveUserDetailsToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.value.id);
    prefs.setString('username', user.value.username);
    prefs.setString('email', user.value.email);
    prefs.setString('phone', user.value.phone);
    prefs.setString('pin', user.value.pin);
  }

  // get user details from local storage
  Future<UserModel?> getUserDetailsFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
    String? pin = prefs.getString('pin');

    if (id == null) {
      return null;
    }

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
    String phone = "$phonePrefix${phoneController.text}".substring(1);
    user.update((val) {
      val!.id = phone;
      val.username = usernameController.text;
      val.email = emailController.text;
      val.phone = phone;
      val.pin = ""; // pin empty during login
    });

    isLoading.value = true;
    try {
      // check if a simmilar user has been registered before
      if (await _checkIfUserAlreadyRegistered(
          user.value.phone, user.value.email)) {
        showErrorToast("User with this phone number or email already exists");
        return;
      }
      // save user details to firebase
      await _firestore
          .collection('users')
          .doc(user.value.phone)
          .set(user.value.toMap());

      // save user info to local storage
      await saveUserDetailsToSharedPrefs();
      // move to create pin screen
      Get.toNamed(AppRoutes.setupPin);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
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

  // check phone
  Future<void> checkPhone() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    String phone = "$phonePrefix${phoneController.text}".substring(1);

    try {
      QuerySnapshot snapshot = await _firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // save phone in getx state
        user.value.phone = phone;

        Get.toNamed(AppRoutes.pinLogin, arguments: phone);
        return;
      }
      // no user with such phone was found
      showErrorToast("No user with the phone number was found");
    } on Exception catch (e) {
      showErrorToast("Login Error: ${e.toString()}");
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // update user details to firebase
  Future<void> updateUserToFirebase() async {
    await _firestore
        .collection('users')
        .doc(user.value.phone)
        .update(user.value.toMap());
  }
}
