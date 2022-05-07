import 'package:flutter/material.dart';

class MasterAttendanceCountDeptView extends StatefulWidget {
  const MasterAttendanceCountDeptView({Key? key}) : super(key: key);

  @override
  State<MasterAttendanceCountDeptView> createState() =>
      _MasterAttendanceCountDeptViewState();
}

class _MasterAttendanceCountDeptViewState
    extends State<MasterAttendanceCountDeptView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Text(
          "Department selector, Month selector, Table(TeacherName, Attendance Percentage)"),
    );
  }
}
