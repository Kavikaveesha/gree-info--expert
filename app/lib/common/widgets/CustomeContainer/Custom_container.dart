import 'package:app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/mediaQuery.dart';

class CurvedCustomContainer extends StatelessWidget {
  const CurvedCustomContainer(
      {super.key, required this.topHeight, required this.child, required this.containerHeight});
  final double topHeight;
  final double containerHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: topHeight,
      ),
      Container(
          width: MediaQueryUtils.getWidth(context),
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), // Adjust the radius as needed
              topRight: Radius.circular(40.0), // Adjust the radius as needed
            ),
            color: MyColors.containerColor, // Example background color
          ),
          child: child)
    ]);
  }
}
