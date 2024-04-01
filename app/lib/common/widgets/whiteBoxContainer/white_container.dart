import 'package:flutter/material.dart';


class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child, required this.width});
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white, // Set the background color to white
          borderRadius: BorderRadius.circular(10), // Set the border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.5), // Set the color and opacity of the shadow
              spreadRadius: 5, // Set the spread radius
              blurRadius: 7, // Set the blur radius
              offset: Offset(0, 3), // Set the offset of the shadow
            ),
          ],
        ),
        child: child);
  }
}
