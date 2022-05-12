// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/dropdowns/course_select.dart';

class AttendanceScreenFacultyMode extends StatefulWidget {
  static const routeName = "screen-attendance-faculty-mode";
  const AttendanceScreenFacultyMode({Key? key}) : super(key: key);

  @override
  State<AttendanceScreenFacultyMode> createState() =>
      _AttendanceScreenFacultyModeState();
}

class _AttendanceScreenFacultyModeState
    extends State<AttendanceScreenFacultyMode> {
  late int selectedCourseId;
  late String selectedCourseDuration;
  late String selectedNoDept;
  late int selectedClassId;
  late int selectedYearId;
  late int selectedSemId;
  late int selectedSubjectId;
  late int selectedLectureDuration;

  void courseSelection(int courseId, String noDept, String courseDuration) {
    setState(() {
      selectedCourseId = courseId;
      selectedCourseDuration = courseDuration;
      selectedNoDept = noDept;
      selectedClassId = 0;
      selectedSemId = 0;
      selectedYearId = 0;
      selectedSubjectId = 0;
      selectedLectureDuration = 1;
    });
  }

  void classSelection(int classId, int yearId, int semId) {
    setState(() {
      selectedClassId = classId;
      selectedYearId = yearId;
      selectedSemId = semId;
      selectedSubjectId = 0;
      selectedLectureDuration = 1;
    });
  }

  void yearSelection(int yearId) {
    setState(() {
      selectedYearId = yearId;
      selectedClassId = 0;
      selectedSemId = 0;
      selectedSubjectId = 0;
      selectedLectureDuration = 1;
    });
  }

  void semSelection(int semId) {
    setState(() {
      selectedSemId = semId;
      selectedSubjectId = 0;
      selectedLectureDuration = 1;
    });
  }

  void subjectSelection(int subjectId) {
    setState(() {
      selectedSubjectId = subjectId;
      selectedLectureDuration = 1;
    });
  }

  @override
  void initState() {
    setState(() {
      selectedCourseId = 0;
      selectedCourseDuration = "0";
      selectedNoDept = "yes";
      selectedClassId = 0;
      selectedSemId = 0;
      selectedYearId = 0;
      selectedSubjectId = 0;
      selectedLectureDuration = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xfff21bce),
                  Color(0xff826cf0),
                ],
              ),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Text(
                "Student",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Student Attendance"),
                  CourseSelector(courseSelection: courseSelection),
                  (selectedCourseId == 0)
                      ? const SizedBox(
                          height: 0,
                        )
                      : (selectedNoDept == 'no')
                          ? const Text("Class Dropdown")
                          : const Text("year + sem dropdown"),
                  (selectedCourseId == 0 ||
                          selectedYearId == 0 ||
                          selectedSemId == 0)
                      ? const SizedBox(
                          height: 0,
                        )
                      : const Text("Subject Dropdown"),
                  (selectedCourseId == 0 ||
                          selectedYearId == 0 ||
                          selectedSemId == 0 ||
                          selectedSubjectId == 0)
                      ? const SizedBox(
                          height: 0,
                        )
                      : const Text("Lecture Duration Dropdown"),
                  (selectedCourseId == 0 ||
                          selectedYearId == 0 ||
                          selectedSemId == 0 ||
                          selectedSubjectId == 0 ||
                          selectedLectureDuration == 0)
                      ? const SizedBox(
                          height: 0,
                        )
                      : const Text("Attendance Table + Submit Button"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
