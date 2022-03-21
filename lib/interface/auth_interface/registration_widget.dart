import 'package:eazyweigh/interface/common/text_field_widget.dart';
import 'package:flutter/material.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({Key? key}) : super(key: key);

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  late TextEditingController usernameController,
      firstNameController,
      lastNameController,
      passwordController,
      confirmController,
      emailController,
      companyNameController;
  bool isPasswordMatching = true;
  int confirmPasswordLength = 0;

  @override
  void initState() {
    usernameController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
    emailController = TextEditingController();
    companyNameController = TextEditingController();
    confirmController.addListener(checkConfirmPassword);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  dynamic checkConfirmPassword() {
    if (confirmController.text.isNotEmpty) {
      if (passwordController.text != confirmController.text) {
        setState(() {
          isPasswordMatching = false;
        });
      } else {
        setState(() {
          isPasswordMatching = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textField(false, usernameController, "Username", false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textField(false, firstNameController, "First Name", false),
                textField(false, lastNameController, "Last Name", false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textField(true, passwordController, "Password", false),
                textField(
                    true,
                    confirmController,
                    isPasswordMatching
                        ? "Confirm Password"
                        : "Passwords don't match.",
                    false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textField(false, emailController, "Email ID", false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textField(false, companyNameController, "Company Name", false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
