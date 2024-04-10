import 'package:advantage/components/primary_button.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/widgets/my_btn_loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final AuthController authController = Get.put(AuthController());
  final List<String> _countryCodes = ["+254", "+1", "+44", "+91"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: Get.theme.textTheme.displaySmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: Get.theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Image.asset('images/ill_register.png'),
              const SizedBox(height: 12),
              Text(
                "Login with your phone",
                style: Get.theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Form(
                key: authController.loginFormKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.colorScheme.onPrimaryContainer,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      dense: true,
                      leading: DropdownButton<String>(
                        underline: const SizedBox(),
                        value: authController.phonePrefix,
                        items: _countryCodes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            authController.phonePrefix = value!;
                          });
                        },
                      ),
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "758826552",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          }
                          if (value.length < 9) {
                            return "Phone number is too short";
                          }
                          if (value.length > 9) {
                            return "Phone number is too long";
                          }

                          return null;
                        },
                        controller: authController.phoneController,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Obx(
                  () => PrimaryButton(
                    onPressed: () {
                      // save details and move to next screen
                      authController.checkPhone();
                    },
                    child: authController.isLoading.value
                        ? const MyBtnLoader(
                            large: true,
                          )
                        : const Text("Verify"),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: Get.theme.textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: "Register",
                        style: Get.theme.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.register);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
