
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container normalButton(BuildContext context, Text text, Function onTop) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 80, 
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), 
      ),
      child: ElevatedButton(
        onPressed: () {
          onTop();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Color.fromARGB(66, 255, 255, 255);
            }
            return const Color.fromARGB(255, 161, 158, 158);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: text, 
      ),
    ),
  );
}
