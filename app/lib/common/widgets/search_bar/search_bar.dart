import 'package:app/common/widgets/text_inputs/text_input_field.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final void Function(String)? onChange;
  final bool? isEnable;

  const CustomSearchBar(
      {super.key,
      this.onTap,
      this.controller,
      this.onChange,
       this.isEnable});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        height: MediaQueryUtils.getHeight(context) * .1,
        child: InputField(
            enable: isEnable,
            onChange: onChange,
            controller: controller,
            maxLines: 1,
            labelText: 'Search....',
            suffixIcon: Icons.search,
            suffixOnTap: onTap),
      ),
    );
  }
}
