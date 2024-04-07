import 'package:app/features/screen/authentication/choose_login/choose.dart';
import 'package:app/features/screen/authentication/common_style/button.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQueryUtils.getHeight(context),
          decoration: BoxDecoration(gradient: MyColors.customGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQueryUtils.getWidth(context) * 0.8,
                height: MediaQueryUtils.getWidth(context) * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Set the shape to circle
                  border: Border.all(
                    // Optional: Add a border if needed
                    color: Colors.black,
                    width: 0.0,
                  ),
                ),
                child: ClipOval(
                  // Clip the image to a circle
                  child: Image.asset(
                    MyImages.plantlogo,
                    width: MediaQueryUtils.getWidth(context) * 0.8,
                    height: MediaQueryUtils.getWidth(context) * 0.8,
                    fit: BoxFit.cover, // Optional: Cover the entire circle
                  ),
                ),
              ),
              SizedBox(height: MediaQueryUtils.getHeight(context) * .05),
              const Text(
                'Grow your green oasis with expert tips!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              CommonButton(
                  btnText: 'Get Started',
                  onTap: () {
                    Get.to(() => ChooseScreen());
                  },
                  isPrimarybtn: false)
            ],
          ),
        ),
      ),
    );
  }
}
