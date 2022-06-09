import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../widgets/common/dropdowns/course_select.dart';
import '../../widgets/common/dropdowns/class_select.dart';
import '../../widgets/common/dropdowns/subject_select.dart';
import '../../widgets/attendance/edit/faculty_mode_student_table.dart';
import '../../widgets/common/dropdowns/year_sem_select.dart';
import '../common/dashboard_screen.dart';

class AttendanceScreenFacultyMode extends StatefulWidget {
  static const routeName = "screen-attendance-faculty-mode";
  const AttendanceScreenFacultyMode({Key? key}) : super(key: key);

  @override
  State<AttendanceScreenFacultyMode> createState() =>
      _AttendanceScreenFacultyModeState();
}

class _AttendanceScreenFacultyModeState
    extends State<AttendanceScreenFacultyMode> {
  int selectedCourseId = 0;
  String selectedCourseDuration = "0";
  String selectedNoDept = 'yes';
  int selectedClassId = 0;
  int selectedYearId = 0;
  int selectedSemId = 0;
  // int selectedSubjectId = 0;
  String selectedLectureDuration = "0";
  final FocusNode _durationFocusNode = FocusNode();

  void courseSelection(int courseId, String noDept, String courseDuration) {
    // if(kDebugMode){

    // }
    setState(() {
      selectedCourseId = courseId;
      selectedCourseDuration = courseDuration;
      selectedNoDept = noDept;
      // selectedClassId = 0;
      // selectedSemId = 0;
      // selectedYearId = 0;
      // selectedSubjectId = 0;
      // selectedLectureDuration = "1";
    });
  }

  void classSelection(int classId, int yearId, int semId) {
    if (kDebugMode) {
      log('call back values');
      log('$classId $yearId $semId');
    }
    setState(() {
      selectedClassId = classId;
      selectedYearId = yearId;
      selectedSemId = semId;
      // selectedSubjectId = 0;
      // selectedLectureDuration = "1";
    });
  }

  void yearSelection(int yearId) {
    setState(() {
      selectedYearId = yearId;
      // selectedClassId = 0;
      // selectedSemId = 0;
      // selectedSubjectId = 0;
      // selectedLectureDuration = "1";
    });
  }

  void semSelection(int semId) {
    setState(() {
      selectedSemId = semId;
      // selectedSubjectId = 0;
      // selectedLectureDuration = "1";
    });
  }

  @override
  void initState() {
    setState(() {
      // selectedCourseId = 0;
      // selectedCourseDuration = "0";
      // selectedNoDept = "yes";
      // selectedClassId = 0;
      // selectedSemId = 0;
      // selectedYearId = 0;
      // selectedSubjectId = 0;
      // selectedLectureDuration = "0";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Student Attendance"),
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
                "Mark",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "View",
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
              alignment: Alignment.center,
              child: const Text("Reconstructing"),
            ),
            Container(
              decoration: const BoxDecoration(),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.60,
              child: SfCalendar(
                view: CalendarView.month,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
