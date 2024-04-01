import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/mediaQuery.dart';

class DataDisplayCard extends StatelessWidget {
  const DataDisplayCard({
    super.key,
    required this.labelText,
    required this.detailtext,
    this.height,
    this.edit,
    this.onTapEdit,
  });
  final String labelText;
  final String detailtext;
  final String? edit;
  final VoidCallback? onTapEdit;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        width: MediaQueryUtils.getWidth(context) * .9,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      labelText,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                        onTap: onTapEdit,
                        child: Text(
                          edit ?? '',
                          style: TextStyle(
                              fontSize: 15,
                              color: TColors.appPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  child: Text(
                    maxLines: 2,
                    detailtext,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: const Color.fromARGB(255, 54, 54, 54)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
