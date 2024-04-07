import 'package:app/common/widgets/CustomeContainer/Custom_container.dart';
import 'package:app/features/controller/authentication_controller.dart';
import 'package:app/features/screen/authentication/common_style/button.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/validators/validation.dart';
import '../common_style/textFieldStyle.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  TextEditingController _emailController = TextEditingController();

  void passwordReset() async {
    // Email validation
    if (!Validator.isValidEmail(_emailController.text.trim())) {
      showDialog(
        builder: (context) {
          return const AlertDialog(
            content: Text('Invalid email format. Please enter a valid email.'),
          );
        },
        context: context,
      );
    } else {
      controller.passwordReset(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.appPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Forgot Password?',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            CurvedCustomContainer(
                topHeight: MediaQueryUtils.getHeight(context) * .05,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Icon(
                        Icons.lock,
                        size: 225,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Text(
                        "submit your email for verification",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: ReusableTextField(
                        validator: Validator.validateEmail,
                        isPasswordType: false,
                        icon: Icons.email,
                        text: "Enter your password",
                        controller: _emailController,
                      ),
                    ),
                    SizedBox(height: 5),
                    CommonButton(
                        btnText: 'Reset Password',
                        onTap: passwordReset,
                        isPrimarybtn: false)
                  ],
                ),
                containerHeight: MediaQueryUtils.getHeight(context) * .9)
          ],
        ),
      ),
    );
  }
}
