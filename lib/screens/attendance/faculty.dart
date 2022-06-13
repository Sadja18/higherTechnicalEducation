import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:higher/widgets/common/date_select.dart';
import 'package:intl/intl.dart';
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
  final FocusNode _durationFocusNode = FocusNode();
  int selectedCourseId = 0;
  int selectedClassId = 0;
  int selectedYearId = 0;
  int selectedSemId = 0;
  int selectedSubjectId = 0;
  String isNoDept = '';
  int selectedCourseDuration = 0;
  String selectedLectureDuration = "0";
  int selectFinalize = 0;

  /// since the database stores date in fullYear-fullMonth-fullDate format
  /// we need a formatter to enable it
  final DateFormat format = DateFormat('yyyy-MM-dd');

  // a variable to store the selected date
  String? _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void reset() {
    setState(() {
      selectedCourseId = 0;
      selectedCourseDuration = 0;
      selectedLectureDuration = "0";
      selectedClassId = 0;
      selectedSemId = 0;
      selectedYearId = 0;
      selectedSubjectId = 0;
      selectFinalize = 0;
    });
  }

  void comeToParentOnAttendanceSubmit() {
    reset();
  }

  // reverse call back to store the selected Date
  void dateSelector(String? selectDate) {
    setState(() {
      _selectedDate = selectDate.toString();
      // currentRowIndex = 0;
      // rowsTapped = [];
      // absenteeMemberData = {};
    });
    if (kDebugMode) {
      print('reverse date callback');
    }
  }
  // reverse call back to store the selected Date end

  void courseSelection(int courseId, String noDept, String courseDurtaion) {
    setState(() {
      selectedCourseId = courseId;
      isNoDept = noDept;
      selectedCourseDuration = int.parse(courseDurtaion);
    });
  }

  void classSelection(int classId, int yearId, int semId) {
    if (kDebugMode) {
      log("parent callback classSelection");
      log("classId: $classId, semId: $semId, yearId: $yearId");
    }
    setState(() {
      selectedClassId = classId;
      selectedYearId = yearId;
      selectedSemId = semId;
    });
  }

  void subjectSelection(int subjectId, int courseId, int yearId, int semId) {
    if (kDebugMode) {
      log("parent callback subject selection");
      log('subjectId $subjectId');
    }
    setState(() {
      selectedSubjectId = subjectId;
    });
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var statusBarHeight = MediaQuery.of(context).padding.top;
    // var appBarHeight = kToolbarHeight;
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
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  // color: Colors.blueGrey,
                  ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Container(
                          alignment: Alignment.center,
                          child: const Text("Selection"),
                        ),
                        children: [
                          Card(
                            elevation: 18.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                children: [
                                  /// selector for date
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: DateShowNew(
                                          dateSelector: dateSelector,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// selector for course
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: CourseSelector(
                                          courseSelection: courseSelection,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// selector bool based class or year sem
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: isNoDept == ''
                                            ? const SizedBox(
                                                height: 0,
                                                width: 0,
                                              )
                                            : isNoDept == 'no'
                                                ? ClassSelector(
                                                    courseId: selectedCourseId,
                                                    classSelection:
                                                        classSelection,
                                                  )
                                                : isNoDept == "yes"
                                                    ? const Text(
                                                        "year sem selector")
                                                    : const SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                      ),
                                    ],
                                  ),

                                  /// subject selector
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: (selectedSemId == 0 ||
                                                selectedYearId == 0)
                                            ? const SizedBox(
                                                height: 0,
                                                width: 0,
                                              )
                                            : SubjectSelector(
                                                courseId: selectedCourseId,
                                                yearId: selectedYearId,
                                                semId: selectedSemId,
                                                subjectSelection:
                                                    subjectSelection,
                                              ),
                                      ),
                                    ],
                                  ),

                                  /// input for lecture duration
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: (selectedSubjectId == 0)
                                            ? const SizedBox(
                                                height: 0,
                                                width: 0,
                                              )
                                            : SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                                child: TextFormField(
                                                  initialValue:
                                                      selectedLectureDuration,
                                                  decoration:
                                                      const InputDecoration(
                                                    focusColor: Colors.purple,
                                                    alignLabelWithHint: true,
                                                    label: Text(
                                                        "Lecture Duration"),
                                                  ),
                                                  cursorColor:
                                                      Colors.pinkAccent,
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  keyboardAppearance:
                                                      Brightness.dark,
                                                  onChanged: (value) {
                                                    if (kDebugMode) {
                                                      log('selectedLectureDuration');
                                                      log(value);
                                                    }
                                                    setState(() {
                                                      selectedLectureDuration =
                                                          value.toString();
                                                    });
                                                  },
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),

                                  /// to confirm or reset selections
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Table(
                                          children: [
                                            TableRow(
                                              children: [
                                                (selectedCourseId == 0 ||
                                                        selectedSemId == 0 ||
                                                        selectedYearId == 0 ||
                                                        selectedSubjectId ==
                                                            0 ||
                                                        selectedLectureDuration ==
                                                            "0" ||
                                                        selectedLectureDuration
                                                            .isEmpty ||
                                                        int.tryParse(
                                                                selectedLectureDuration) ==
                                                            null)
                                                    ? const SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      )
                                                    : TableCell(
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              selectFinalize =
                                                                  1;
                                                            });
                                                          },
                                                          child: Card(
                                                            elevation: 10.0,
                                                            color: Colors.green,
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.30,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                // border: Border.all(
                                                                //   color: Colors.white,
                                                                // ),
                                                              ),
                                                              child: const Text(
                                                                "Confirm",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                TableCell(
                                                  child: InkWell(
                                                    onTap: () {
                                                      reset();
                                                    },
                                                    child: Card(
                                                      elevation: 10.0,
                                                      color: Colors.blue,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.30,
                                                        margin: const EdgeInsets
                                                            .symmetric(),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          // border: Border.all(
                                                          //   color: Colors.white,
                                                          // ),
                                                        ),
                                                        child: const Text(
                                                          "Reset",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// attendance table generator
                    (selectedCourseId == 0 ||
                            selectedSemId == 0 ||
                            selectedYearId == 0 ||
                            selectedSubjectId == 0 ||
                            selectedLectureDuration == "0" ||
                            selectedLectureDuration.isEmpty ||
                            int.tryParse(selectedLectureDuration) == null ||
                            selectFinalize == 0)
                        ? const SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : FacultyModeStudentAttendanceTable(
                            lectureDuration: selectedLectureDuration,
                            subjectId: selectedSubjectId,
                            courseId: selectedCourseId,
                            semId: selectedSemId,
                            yearId: selectedYearId,
                            attendanceDate: _selectedDate.toString(),
                            classId: selectedClassId,
                            comeBackToParentCallBack:
                                comeToParentOnAttendanceSubmit,
                          ),
                  ],
                ),
              ),
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
