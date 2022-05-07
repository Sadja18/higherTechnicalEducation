import 'package:flutter/material.dart';

class HeadAttendanceCountDeptView extends StatefulWidget {
  const HeadAttendanceCountDeptView({Key? key}) : super(key: key);

  @override
  State<HeadAttendanceCountDeptView> createState() =>
      _HeadAttendanceCountDeptViewState();
}

class _HeadAttendanceCountDeptViewState
    extends State<HeadAttendanceCountDeptView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Text(
          "Month selector, Table(TeacherName, Attendance Percentage)"),
    );
  }
}
