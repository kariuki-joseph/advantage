import 'package:advantage/components/primary_button.dart';
import 'package:advantage/routes/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final List<String> _countryCodes = ["+254", "+1", "+44", "+91"];

  String drowpdownValue = "+254";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                "We will send you a verification code to the number provided",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  DropdownButton<String>(
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
                      decoration: const InputDecoration(hintText: "758826552"),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _isLoading = true;
                      });
                      // move to the next screen
                      Get.toNamed(AppPage.verifyPhone);
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Verify"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
