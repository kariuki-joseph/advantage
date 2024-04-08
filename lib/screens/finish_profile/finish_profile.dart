import 'package:advantage/components/primary_button.dart';
import 'package:advantage/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinishProfile extends StatefulWidget {
  const FinishProfile({super.key});

  @override
  State<FinishProfile> createState() => _FinishProfileState();
}

class _FinishProfileState extends State<FinishProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Finish setting up your profile",
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              TextFormField(
                enabled: false,
                decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "0114662464",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "someone@gmail.com",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    labelText: "Username",
                    hintText: "Joe Dev",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 50,
              ),
              PrimaryButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.setupPin);
                },
                child: const Text("Finish"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
