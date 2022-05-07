import 'package:flutter/material.dart';

import '../../services/connection/base.dart';

class DropdownDeptSelector extends StatefulWidget {
  const DropdownDeptSelector({Key? key}) : super(key: key);

  @override
  State<DropdownDeptSelector> createState() => _DropdownDeptSelectorState();
}

class _DropdownDeptSelectorState extends State<DropdownDeptSelector> {
  late var selectedDept = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      child: FutureBuilder(
          future: getDepartmentDataFromServerMasterMode(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.isNotEmpty) {
              var departmentData = snapshot.data;
              return Text(departmentData.toString());
            }
            return const Text("data");
          }),
    );
  }
}
