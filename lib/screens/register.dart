import 'package:advantage/components/primary_button.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/widgets/my_btn_loader.dart';
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

  String drowpdownValue = "+254";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              const Text(
                "Create An Account With Us",
                style: TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      underline: const SizedBox(),
                      value: drowpdownValue,
                      items: _countryCodes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          drowpdownValue = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "758826552",
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
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
                        onChanged: (value) {
                          authController.phone.value = "$drowpdownValue$value";
                        },
                        controller: authController.phoneController,
                      ),
                    ),
                  ],
                ),
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
              const SizedBox(height: 50),
              Obx(
                () => PrimaryButton(
                  onPressed: () {
                    // save details and move to next screen
                    authController.registerUser();
                  },
                  child: authController.isLoading
                      ? const MyBtnLoader(
                          large: true,
                          color: Colors.white,
                        )
                      : const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
