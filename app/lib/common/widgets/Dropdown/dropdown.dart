// import 'package:flutter/material.dart';

// class Dropdown01 extends StatefulWidget {
//   Dropdown01({
//     Key? key,
//     required this.listName,
//     required this.onSelected,
//     this.selectedItem,
//   }) : super(key: key);

//   final List<String> listName;
//   final Function(String) onSelected;
//   final String? selectedItem;

//   @override
//   _Dropdown01State createState() => _Dropdown01State();
// }

// class _Dropdown01State extends State<Dropdown01> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.9,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.grey),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: DropdownButton<String>(
//             icon: Icon(Icons.keyboard_arrow_down),
//             iconEnabledColor: Colors.black,
//             iconSize: 30,
//             value: widget.selectedItem,
//             style: Theme.of(context).textTheme.headlineSmall,
//             onChanged: (newValue) {
//               setState(() {
//                 widget.onSelected(newValue!);
//               });
//             },
//             items: widget.listName.map((name) {
//               return DropdownMenuItem<String>(
//                 value: name,
//                 child: Text(name),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
