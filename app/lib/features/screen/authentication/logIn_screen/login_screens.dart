import 'package:app/navigation.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/CustomeContainer/Custom_container.dart';
import '../../../../common/widgets/snack_bar/snack_bar.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../../controller/authentication_controller.dart';
import '../common_style/button.dart';
import '../common_style/text.dart';
import '../common_style/textFieldStyle.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../register_screen/register_screen2.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}); // Corrected the key parameter

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  Future<void> signIn() async {
    try {
      controller.signIn(
        _emailTextController.text.trim(),
        _passwordTextController.text.trim(),
      );
    } catch (e) {
      SnackbarHelper.showSnackbar(
        backgroundColor: Colors.red,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.appPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQueryUtils.getHeight(context) * .1,
                ),
                Text(
                    textAlign: TextAlign.center,
                    'Sign In Now',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white)),
              ],
            ),
            CurvedCustomContainer(
              topHeight: MediaQueryUtils.getHeight(context) * 0.05,
              containerHeight: MediaQueryUtils.getHeight(context) -
                  MediaQueryUtils.getHeight(context) * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: MediaQueryUtils.getHeight(context) * .01),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        MyImages.loginImg,
                        width: MediaQueryUtils.getWidth(context) * .6,
                      ),
                    ),
                    ReusableTextField(
                      validator: Validator.validateEmail,
                      isPasswordType: false,
                      icon: Icons.email,
                      text: "Enter Email",
                      controller: _emailTextController,
                    ),
                    SizedBox(height: 25),
                    ReusableTextField(
                      validator: Validator.validatePassword,
                      isPasswordType: true,
                      icon: Icons.password,
                      text: "Enter password",
                      controller: _passwordTextController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonButton(
                            btnText: 'Sign In',
                            onTap: signIn,
                            isPrimarybtn: false),
                        signUpSignInOption()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row signUpSignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Color.fromARGB(255, 220, 72, 72),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
