import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/connection/faculty_mode_fetches.dart';

class FacultyModeStudentAttendanceTable extends StatefulWidget {
  final int courseId;
  final int yearId;
  final int semId;
  const FacultyModeStudentAttendanceTable({
    Key? key,
    required this.courseId,
    required this.yearId,
    required this.semId,
  }) : super(key: key);

  @override
  State<FacultyModeStudentAttendanceTable> createState() =>
      _FacultyModeStudentAttendanceTableState();
}

class _FacultyModeStudentAttendanceTableState
    extends State<FacultyModeStudentAttendanceTable> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      log("${widget.courseId} ${widget.yearId} ${widget.semId}");
    }
    return FutureBuilder(
      future: getStudentDataCourseIdYearIdSemId(
        widget.courseId,
        widget.yearId,
        widget.semId,
      ),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 6.0,
            ),
          );
        } else {
          if (snapshot.hasError ||
              snapshot.hasData != true ||
              snapshot.data == null ||
              snapshot.data.isNotEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              child: Text("No students for selected details"),
            );
          } else {
            var students = snapshot.data;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(students),
              ),
            );
          }
        }
      },
    );
  }
}
