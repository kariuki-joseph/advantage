import 'package:advantage/components/primary_button.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/widgets/my_btn_loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List<String> _countryCodes = ["+254", "+1", "+44", "+91"];
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: authController.registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "images/ill_register.png",
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                "Create An Account With Us",
                style: Get.theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter Username",
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                controller: authController.usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username is required";
                  }
                  if (value.length < 3) {
                    return "Username is too short";
                  }
                  if (value.length > 20) {
                    return "Username is too long";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter Email",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: authController.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!value.contains("@")) {
                    return "Invalid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Container(
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
                    contentPadding: EdgeInsets.zero,
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
              const SizedBox(height: 50),
              Obx(
                () => PrimaryButton(
                  onPressed: () {
                    // save details and move to next screen
                    authController.registerUser();
                  },
                  child: authController.isLoading.value
                      ? const MyBtnLoader(
                          large: true,
                        )
                      : const Text("Get Started"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: Get.theme.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: "Login",
                        style: Get.theme.textTheme.bodyLarge?.copyWith(
                          color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.toNamed(AppRoutes.phoneLogin),
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
