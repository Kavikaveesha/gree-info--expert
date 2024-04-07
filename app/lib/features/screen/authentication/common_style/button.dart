import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import '/utils/constants/mediaQuery.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.btnText,
    required this.onTap,
    required this.isPrimarybtn,
  }) : super(key: key);

  final String btnText;
  final VoidCallback onTap;
  final bool isPrimarybtn;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        isPrimarybtn ? MyColors.primaryBtnColor : Colors.white;
    Color textColor = isPrimarybtn ? Colors.white : MyColors.primaryBtnColor;
    return Container(
      width: MediaQueryUtils.getWidth(context) * .8,
      height: MediaQueryUtils.getHeight(context) * .07,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          btnText, // Fixed variable name here
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
