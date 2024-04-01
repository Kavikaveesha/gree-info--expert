import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.labelText,
    this.controller,
    this.validator,
    this.keyboardtype,
    this.maxLength,
    this.maxLines,
    this.icon,
  }) : super(key: key);
  final IconData? icon;
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardtype;
  final int? maxLength;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      width: mediaQueryWidth * 1,
      child: TextFormField(
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardtype,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Set border radius to 15
          ),
        ),
      ),
    );
  }
}
