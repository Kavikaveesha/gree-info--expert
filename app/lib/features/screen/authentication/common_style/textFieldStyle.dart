import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordType;
  final IconData icon;
  final String text;
   final String? Function(String?)? validator;

  const ReusableTextField({
    Key? key,
    required this.isPasswordType,
    required this.icon,
    required this.text, this.validator, required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: const Color.fromARGB(255, 114, 97, 97),
      style: TextStyle(color: Colors.white.withOpacity(0.8)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 240, 245, 149),
        ),
        labelText: text,
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 243, 227, 126).withOpacity(0.9),
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Color.fromARGB(255, 101, 84, 84).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}
