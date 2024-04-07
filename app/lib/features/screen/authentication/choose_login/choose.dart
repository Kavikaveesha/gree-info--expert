import 'package:app/common/widgets/CustomeContainer/Custom_container.dart';
import 'package:app/features/screen/authentication/common_style/button.dart';
import 'package:app/features/screen/authentication/logIn_screen/login_screens.dart';
import 'package:app/features/screen/authentication/register_screen/register_screen2.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/mediaQuery.dart';
import '../common_style/text.dart';

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({super.key});

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.appPrimaryColor,
      body: SingleChildScrollView(
        child: CurvedCustomContainer(
          topHeight: MediaQueryUtils.getHeight(context) * .2,
          containerHeight: MediaQueryUtils.getHeight(context) -
              MediaQueryUtils.getHeight(context) * .2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQueryUtils.getHeight(context) * .02,
              ),
              Image.asset(
                MyImages.greentips,
                width: MediaQueryUtils.getWidth(context) * .9,
              ),
              Center(
                child: Text(
                    textAlign: TextAlign.center,
                    GTexts.chooseHeader,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white)),
              ),
              SizedBox(
                height: MediaQueryUtils.getHeight(context) * .03,
              ),
              CommonButton(
                  btnText: 'Register',
                  onTap: () {
                    Get.to(() => SignUpScreen());
                  },
                  isPrimarybtn: true),
              SizedBox(
                height: MediaQueryUtils.getHeight(context) * .005,
              ),
              CommonButton(
                  btnText: 'Sign In',
                  onTap: () {
                    Get.to(() => LogInScreen());
                  },
                  isPrimarybtn: false),
            ],
          ),
        ),
      ),
    );
  }
}
