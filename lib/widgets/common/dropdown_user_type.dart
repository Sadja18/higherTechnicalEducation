import 'package:flutter/material.dart';

class DropdownUserType extends StatefulWidget {
  final Function(String) userTypeSelector;
  const DropdownUserType({Key? key, required this.userTypeSelector})
      : super(key: key);

  @override
  State<DropdownUserType> createState() => _DropdownUserTypeState();
}

class _DropdownUserTypeState extends State<DropdownUserType> {
  String selectedUserType = 'Teaching Staff';
  List<String> userTypes = [
    "Head of Institution",
    "Head of Department",
    "Teaching Staff",
    "Non-Teaching Staff",
    "Parent",
    "Student",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.080,
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: DropdownButton(
        dropdownColor: Colors.deepPurpleAccent,
        value: selectedUserType,
        icon: const Icon(Icons.arrow_downward),
        items: userTypes.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              // decoration: BoxDecoration(),
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedUserType = value!;
          });

          widget.userTypeSelector(selectedUserType);
        },
      ),
    );
  }
}
