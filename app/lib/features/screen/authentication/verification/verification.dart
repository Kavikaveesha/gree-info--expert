import 'package:app/features/screen/authentication/common_style/button.dart';
import 'package:app/features/screen/authentication/common_style/normal_button.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/snack_bar/snack_bar.dart';
import '../../../controller/authentication_controller.dart';
import '../logIn_screen/login_screens.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  Future<void> verifyUser() async {
    if (await controller.isEmailVerified()) {
      SnackbarHelper.showSnackbar(
          title: 'Verification Success',
          message: 'Your Account has verficate.SignIn to Procced!');
      Future.delayed(Duration(milliseconds: 2), () {
        Get.to(() => LogInScreen());
      });
    } else {
      SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Verification Failed',
          message: 'Please Verify Your Email');
    }
  }

  Future<void> resendEmail() async {
    // Send verification email
    User? user = _auth.currentUser;
    await user!.sendEmailVerification();
    SnackbarHelper.showSnackbar(
        title: 'Resend Verification Email',
        message: 'Verification Email has been sent.Check your Email!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQueryUtils.getWidth(context),
          height: MediaQueryUtils.getHeight(context),
          decoration: BoxDecoration(gradient: MyColors.customGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQueryUtils.getHeight(context) * .1,
              ),
              Text(
                'Verification',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(90, 80, 90, 20),
                child: Icon(Icons.lock, size: 225),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  textAlign: TextAlign.center,
                  'Input the verification code from your email',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              SizedBox(
                height: MediaQueryUtils.getHeight(context) * .05,
              ),
              CommonButton(
                  btnText: 'Resend', onTap: resendEmail, isPrimarybtn: true),
              CommonButton(
                  btnText: 'Verify', onTap: verifyUser, isPrimarybtn: false),
            ],
          ),
        ),
      ),
    );
  }
}
