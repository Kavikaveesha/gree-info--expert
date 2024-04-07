import 'package:app/common/widgets/CustomeContainer/Custom_container.dart';
import 'package:app/common/widgets/snack_bar/snack_bar.dart';
import 'package:app/features/controller/authentication_controller.dart';
import 'package:app/features/screen/authentication/common_style/button.dart';
import 'package:app/features/screen/authentication/logIn_screen/login_screens.dart';
import 'package:app/features/screen/authentication/verification/verification.dart';
import 'package:app/utils/validators/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/mediaQuery.dart';
import '../common_style/textFieldStyle.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  final TextEditingController _userNameTextcontroller = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  bool _agreeToTerms = false;

  void signUp() {
    if (_formKey.currentState!.validate()) {
      if (Validator.isValidEmail(_emailTextController.text.trim())) {
        if (_agreeToTerms) {
          if (_passwordTextController.text.trim() ==
              _confirmPasswordTextController.text.trim()) {
            // Sign up user
            controller.signUp(
                _emailTextController.text.trim(),
                _userNameTextcontroller.text.trim(),
                _passwordTextController.text.trim());

            SnackbarHelper.showSnackbar(
                title: 'Verificating Email',
                message: 'Verification Email has been sent.Check your Email!');

            Future.delayed(Duration(milliseconds: 2), () {
              Get.to(() => Verification());
            });
          } else {
            SnackbarHelper.showSnackbar(
                backgroundColor: Colors.red,
                title: 'Error',
                message: 'Passowrd and conform password not maching!');
          }
        } else {
          SnackbarHelper.showSnackbar(
              backgroundColor: Colors.red,
              title: 'Error',
              message: 'Please accept Terms and conditions!');
        }
      } else {
        SnackbarHelper.showSnackbar(
            backgroundColor: Colors.red,
            title: 'Error',
            message: 'Please Enter Valid Email!');
      }
    } else {
      SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'Please Fill All Fields!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.appPrimaryColor,
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: MediaQueryUtils.getHeight(context) * .1,
          ),
          Text(
              textAlign: TextAlign.center,
              'Create New Account',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white)),
          CurvedCustomContainer(
            topHeight: MediaQueryUtils.getHeight(context) * 0.1,
            containerHeight: MediaQueryUtils.getHeight(context) * 1.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQueryUtils.getHeight(context) * .01),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        MyImages.loginImg,
                        width: MediaQueryUtils.getWidth(context) * .6,
                      ),
                    ),
                    ReusableTextField(
                      validator: Validator.validFullName,
                      isPasswordType: false,
                      icon: Icons.person,
                      text: "Enter Your Full Name",
                      controller: _userNameTextcontroller,
                    ),
                    const SizedBox(height: 20),
                    ReusableTextField(
                      validator: Validator.validateEmail,
                      isPasswordType: false,
                      icon: Icons.email,
                      text: "Enter Your Email",
                      controller: _emailTextController,
                    ),
                    const SizedBox(height: 20),
                    ReusableTextField(
                      validator: Validator.validatePassword,
                      isPasswordType: false,
                      icon: Icons.lock_clock,
                      text: "Enter Strong password",
                      controller: _passwordTextController,
                    ),
                    const SizedBox(height: 20),
                    ReusableTextField(
                      validator: Validator.validatePassword,
                      isPasswordType: false,
                      icon: Icons.lock_clock,
                      text: "Comform Your password",
                      controller: _confirmPasswordTextController,
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      title: InkWell(
                        onTap: () {},
                        child: const Text(
                          "I agree to the TEAM & CONDITION and privacy policy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      value: _agreeToTerms,
                      onChanged: (newValue) {
                        setState(() {
                          _agreeToTerms = newValue ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        CommonButton(
                            btnText: 'Register',
                            isPrimarybtn: false,
                            onTap: signUp),
                        SizedBox(
                            height: MediaQueryUtils.getHeight(context) * .02),
                        signUpSignInOption(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Row signUpSignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an Account?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogInScreen()),
            );
          },
          child: const Text(
            " Sign In",
            style: TextStyle(
              color: Colors.red,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
