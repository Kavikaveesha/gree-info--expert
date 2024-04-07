import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/snack_bar/snack_bar.dart';
import '../../authentication/common_style/textFieldStyle.dart';
import '/features/controller/authentication_controller.dart';
import '/utils/validators/validation.dart';
import '/common/widgets/CustomeContainer/Custom_container.dart';
import '/features/screen/authentication/common_style/button.dart';
import '/utils/constants/colors.dart';
import '/utils/constants/mediaQuery.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthenticationController controller =
      Get.put(AuthenticationController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  void changePassword() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with password change
      if (_newPasswordController.text.trim() ==
          _confirmNewPasswordController.text.trim()) {
        // Reset password
        controller.changePassword(
          _currentPasswordController.text.trim(),
          _newPasswordController.text.trim(),
        );
       
        setState(() {
          _confirmNewPasswordController.clear();
          _newPasswordController.clear();
          _confirmNewPasswordController.clear();
        });
      } else {
        SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'New Password and Confirm New Password do not match!',
        );
      }
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
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Create \nnew password',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                CurvedCustomContainer(
                  topHeight: MediaQueryUtils.getHeight(context) * .1,
                  containerHeight: MediaQueryUtils.getHeight(context) -
                      MediaQueryUtils.getHeight(context) * .1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQueryUtils.getHeight(context) * .05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 5,
                        ),
                        child: Text(
                          "Create your\nnew password is \ndistrict from previous one",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                        child: Column(
                          children: [
                            ReusableTextField(
                              validator: Validator.validatePassword,
                              isPasswordType: true,
                              icon: Icons.password,
                              text: "Current Password",
                              controller: _currentPasswordController,
                            ),
                            SizedBox(height: 30),
                            ReusableTextField(
                              validator: Validator.validatePassword,
                              isPasswordType: false,
                              icon: Icons.lock_clock_outlined,
                              text: "New Password",
                              controller: _newPasswordController,
                            ),
                            SizedBox(height: 30),
                            ReusableTextField(
                              validator: (value) {
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              isPasswordType: false,
                              icon: Icons.lock_clock_outlined,
                              text: "Confirm New Password",
                              controller: _confirmNewPasswordController,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: CommonButton(
                          btnText: 'Reset Password',
                          onTap: changePassword,
                          isPrimarybtn: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
