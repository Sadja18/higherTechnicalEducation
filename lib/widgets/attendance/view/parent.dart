import 'package:flutter/material.dart';

class ParentAttendanceCountDeptView extends StatefulWidget {
  const ParentAttendanceCountDeptView({Key? key}) : super(key: key);

  @override
  State<ParentAttendanceCountDeptView> createState() =>
      _ParentAttendanceCountDeptViewState();
}

class _ParentAttendanceCountDeptViewState
    extends State<ParentAttendanceCountDeptView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Text("Child Selector, Month wise percentage"),
    );
  }
}
