import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/dropdowns/course_select.dart';
import '../../widgets/common/dropdowns/class_select.dart';
import '../../widgets/common/dropdowns/subject_select.dart';
import '../../widgets/attendance/edit/faculty_mode_student_table.dart';
import '../../widgets/common/dropdowns/year_sem_select.dart';

class AttendanceScreenFacultyMode extends StatefulWidget {
  static const routeName = "screen-attendance-faculty-mode";
  const AttendanceScreenFacultyMode({Key? key}) : super(key: key);

  @override
  State<AttendanceScreenFacultyMode> createState() =>
      _AttendanceScreenFacultyModeState();
}

class _AttendanceScreenFacultyModeState
    extends State<AttendanceScreenFacultyMode> {
  late int selectedCourseId = 0;
  late String selectedCourseDuration = "0";
  late String selectedNoDept = 'yes';
  late int selectedClassId = 0;
  late int selectedYearId = 0;
  late int selectedSemId = 0;
  late int selectedSubjectId = 0;
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

  void subjectSelection(int subjectId, int courseId, int yearId, int semId) {
    setState(() {
      selectedSubjectId = subjectId;
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
        drawer: Container(
          margin: EdgeInsets.only(top: statusBarHeight + appBarHeight + 1),
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const Text("Student Attendance"),
              CourseSelector(
                courseSelection: courseSelection,
              ),
              (selectedCourseId == 0)
                  ? const SizedBox(
                      height: 0,
                    )
                  : (selectedNoDept == 'no')
                      ? ClassSelector(
                          // key: ObjectKey(
                          // "$selectedCourseId $selectedClassId"),
                          courseId: selectedCourseId,
                          classSelection: classSelection,
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.50),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: YearDropdown(
                                        yearSelection: yearSelection),
                                  ),
                                ],
                              ),
                              (selectedYearId == 0)
                                  ? const TableRow(
                                      children: [
                                        TableCell(
                                          child: SizedBox(
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : TableRow(
                                      children: [
                                        TableCell(
                                          child: SemDrodown(
                                            semSelection: semSelection,
                                            yearId: selectedYearId,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
              (selectedCourseId == 0 ||
                      selectedYearId == 0 ||
                      selectedSemId == 0)
                  ? const SizedBox(
                      height: 0,
                    )
                  : SubjectSelector(
                      // key: ObjectKey("$selectedCourseId"),
                      courseId: selectedCourseId,
                      yearId: selectedYearId,
                      semId: selectedSemId,
                      subjectSelection: subjectSelection,
                    ),
              (selectedCourseId == 0 ||
                      selectedYearId == 0 ||
                      selectedSemId == 0 ||
                      selectedSubjectId == 0)
                  ? const SizedBox(
                      height: 0,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FractionColumnWidth(0.50),
                          1: FractionColumnWidth(0.50),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Text(
                                    "Duration: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: TextFormField(
                                    // initialValue: selectedLectureDuration,
                                    textAlign: TextAlign.center,
                                    controller: TextEditingController(
                                        text: selectedLectureDuration),
                                    keyboardType: TextInputType.number,
                                    focusNode: _durationFocusNode,
                                    decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      hintText: "Duration",
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    onChanged: (value) {
                                      if (int.tryParse(value.toString()) !=
                                          null) {
                                        setState(() {
                                          setState(() {
                                            selectedLectureDuration =
                                                value.toString();
                                          });
                                        });
                                      }
                                      _durationFocusNode.unfocus();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: MediaQuery.of(context).size.height * 0.05,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            (selectedCourseId == 0 ||
                    selectedYearId == 0 ||
                    selectedSemId == 0 ||
                    selectedSubjectId == 0 ||
                    selectedLectureDuration == "0")
                ? const SizedBox(
                    height: 0,
                  )
                : FacultyModeStudentAttendanceTable(
                    courseId: selectedCourseId,
                    yearId: selectedYearId,
                    semId: selectedSemId,
                  ),
          ],
        ),
      ),
    );
  }
}
