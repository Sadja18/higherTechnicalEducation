// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../../../services/connection/faculty_mode_methods.dart';

class FacultyModeStudentAttendanceTable extends StatefulWidget {
  final int subjectId;
  final String lectureDuration;
  final int courseId;
  final int yearId;
  final int semId;
  final String attendanceDate;
  final int classId;
  final VoidCallback comeBackToParentCallBack;
  const FacultyModeStudentAttendanceTable({
    Key? key,
    required this.courseId,
    required this.yearId,
    required this.semId,
    required this.subjectId,
    required this.lectureDuration,
    required this.attendanceDate,
    required this.classId,
    required this.comeBackToParentCallBack,
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
              snapshot.data.isEmpty) {
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
              child: StudentAttendanceView(
                  subjectId: widget.subjectId,
                  semId: widget.semId,
                  yearId: widget.yearId,
                  courseId: widget.courseId,
                  classId: widget.classId,
                  attendanceDate: widget.attendanceDate,
                  lectureDuration: widget.lectureDuration,
                  students: students,
                  comeBackToParentCallBack: widget.comeBackToParentCallBack),
            );
          }
        }
      },
    );
  }
}

class StudentAttendanceView extends StatefulWidget {
  final List students;
  final int subjectId;
  final int courseId;
  final int yearId;
  final int semId;
  final int classId;
  final String lectureDuration;
  final String attendanceDate;
  final VoidCallback comeBackToParentCallBack;
  const StudentAttendanceView({
    Key? key,
    required this.students,
    required this.subjectId,
    required this.courseId,
    required this.yearId,
    required this.semId,
    required this.classId,
    required this.lectureDuration,
    required this.attendanceDate,
    required this.comeBackToParentCallBack,
  }) : super(key: key);

  @override
  State<StudentAttendanceView> createState() => _StudentAttendanceViewState();
}

class _StudentAttendanceViewState extends State<StudentAttendanceView> {
  List<int> absenteeStudentIds = [];
  late List students;
  late Map<int, Color> rowColors;
  int currentRowIndex = 0;
  ScrollController verticalBodyController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController verticalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalBodyController =
      ScrollController(initialScrollOffset: 0.0);

  Widget rowsTitleBuilder(rowIndex) {
    var studentName = students[rowIndex]['studentName'];
    var studentId = students[rowIndex]['studentId'];
    var profilePic = students[rowIndex]['profilePic'];
    var rowColor = rowColors[studentId];
    return Container(
      alignment: Alignment.center,
      child: Card(
        elevation: 10.0,
        shadowColor: Colors.blue.shade200,
        color: rowColor,
        child: InkWell(
          onTap: () {
            var tmpAbsenteeList = absenteeStudentIds;

            if (tmpAbsenteeList.contains(studentId)) {
              tmpAbsenteeList.removeWhere((element) => element == studentId);
              setState(() {
                absenteeStudentIds = tmpAbsenteeList;
                rowColors[studentId] = Colors.green;
              });
            } else {
              tmpAbsenteeList.add(studentId);
              setState(() {
                absenteeStudentIds = tmpAbsenteeList;
                rowColors[studentId] = Colors.red;
              });
            }
          },
          child: StudentRow(
            studentName: studentName,
            profilePic: profilePic,
            studentId: studentId,
            rowColor: rowColors[studentId]!,
          ),
        ),
      ),
    );
  }

  double verticalRowScrollOffset() {
    double scrollOffset = 75.0;
    if (currentRowIndex == 0.0) {
      return 0.0;
    } else {
      return scrollOffset * currentRowIndex;
    }
  }

  ScrollControllers scrollControllers() {
    return ScrollControllers(
      verticalTitleController: verticalTitleController,
      verticalBodyController: verticalBodyController,
      horizontalTitleController: horizontalTitleController,
      horizontalBodyController: horizontalBodyController,
    );
  }

  void showAbsentStudentsPreview() async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Center(child: const Text("Absent Students")),
            content: Container(
              margin: const EdgeInsets.only(
                left: 4.0,
              ),
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.60,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    columnWidths: const {
                      0: FractionColumnWidth(0.30),
                      1: FractionColumnWidth(0.70),
                    },
                    children: const [
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Text(
                                'Student ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                'Student Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        // columnWidths: const {
                        //   0: FractionColumnWidth(0.30),
                        //   1: FractionColumnWidth(0.70),
                        // }
                        children: absenteeStudentIds.map((studentId) {
                          String studentName = "";
                          for (var student in students) {
                            if (studentId == student['studentId']) {
                              studentName = student['studentName'];
                            }
                          }
                          return TableRow(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              TableCell(
                                child: Text(studentId.toString()),
                              ),
                              TableCell(
                                child: Text(studentName),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showLoader(submissionDate) {
    showDialog(
        context: context,
        builder: (BuildContext _) {
          return const AlertDialog(
            title: Text("Saving student attendance records"),
            content: SizedBox(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        });
    saveStudentAttendance(
      widget.attendanceDate,
      submissionDate,
      widget.subjectId,
      widget.classId,
      widget.lectureDuration,
      widget.semId,
      widget.yearId,
      widget.courseId,
      absenteeStudentIds,
    );
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext _) {
          return const AlertDialog(
            title: Text("Saved the student attendance successfully"),
            content: SizedBox(
              height: 0,
              width: 0,
            ),
          );
        });
    widget.comeBackToParentCallBack();
  }

  void showAbsentStudentsPreviewSubmit() async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            // ignore: unnecessary_null_comparison
            title: (absenteeStudentIds != null && absenteeStudentIds.isNotEmpty)
                ? Center(child: const Text("Absent Students"))
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
            contentPadding: absenteeStudentIds.isEmpty
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(
                    vertical: 3.0,
                  ),
            content: absenteeStudentIds.isEmpty
                ? const SizedBox(
                    height: 0,
                  )
                : Container(
                    // width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height * 0.60,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Table(
                          // border: TableBorder.all(),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.top,
                          columnWidths: const {
                            0: FractionColumnWidth(0.30),
                            1: FractionColumnWidth(0.70),
                          },
                          children: const [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      'Student ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      'Student Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: MediaQuery.of(context).size.height * 0.40,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: absenteeStudentIds.map(
                                (studentId) {
                                  String studentName = "";
                                  for (var student in students) {
                                    if (studentId == student['studentId']) {
                                      studentName = student['studentName'];
                                    }
                                  }
                                  return Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FractionColumnWidth(0.30),
                                      1: FractionColumnWidth(0.70),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(studentId.toString()),
                                          ),
                                          TableCell(
                                            child: Text(studentName),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            actions: [
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FractionColumnWidth(0.50),
                  1: FractionColumnWidth(0.50),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            decoration: BoxDecoration(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: InkWell(
                          onTap: () {
                            if (kDebugMode) {
                              log('saving to local db');
                            }
                            var submissionDate =
                                DateFormat('yyyy-MM-dd hh:mm:ss')
                                    .format(DateTime.now());
                            // Navigator.of(context).pop();

                            showLoader(submissionDate);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            decoration: BoxDecoration(),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    setState(() {
      students = widget.students;
    });
    Map<int, Color> tmp = {};
    for (var student in students) {
      var studentId = student['studentId'];
      tmp[studentId] = Colors.green;
    }
    setState(() {
      rowColors = tmp;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.08,
            margin: const EdgeInsets.symmetric(
              vertical: 3.0,
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FractionColumnWidth(0.30),
                1: FractionColumnWidth(0.30),
                2: FractionColumnWidth(0.30),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        "Total: ${students.length}",
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Present: ${students.length - absenteeStudentIds.length}",
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    TableCell(
                      child: InkWell(
                        onTap: () {
                          if (absenteeStudentIds.isNotEmpty) {
                            showAbsentStudentsPreview();
                          }
                        },
                        child: Text(
                          "Absent: ${absenteeStudentIds.length}",
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
            child: StickyHeadersTable(
              cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
                columnWidths: [],
                rowHeights:
                    List<double>.generate(students.length, (int index) => 90),
                stickyLegendWidth: MediaQuery.of(context).size.width,
                stickyLegendHeight: 0,
              ),
              initialScrollOffsetX: 0.0,
              initialScrollOffsetY: verticalRowScrollOffset(),
              scrollControllers: scrollControllers(),
              columnsLength: 0,
              rowsLength: students.length,
              columnsTitleBuilder: (i) => const SizedBox(
                height: 0,
              ),
              rowsTitleBuilder: rowsTitleBuilder,
              contentCellBuilder: (i, j) => const SizedBox(
                height: 0,
              ),
              legendCell: const SizedBox(
                height: 0,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showAbsentStudentsPreviewSubmit();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Card(
                elevation: 18.0,
                color: Colors.purpleAccent.shade200,
                shadowColor: Colors.redAccent.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.shade200,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: 3.0,
                  ),
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const Text(
                    'Submit',
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
    );
  }
}

class StudentRow extends StatelessWidget {
  final String studentName;
  final String profilePic;
  final int studentId;
  final Color rowColor;
  const StudentRow({
    Key? key,
    required this.studentName,
    required this.profilePic,
    required this.studentId,
    required this.rowColor,
  }) : super(key: key);
  String nameFormat(studentName) {
    return toBeginningOfSentenceCase(studentName).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: rowColor),
      child: Table(
        columnWidths: const {
          0: FractionColumnWidth(0.40),
          1: FractionColumnWidth(0.60),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              TableCell(
                child: StudentAvatarGenerator(
                  profilePic: profilePic,
                ),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            nameFormat(studentName),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            studentId.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StudentAvatarGenerator extends StatelessWidget {
  final String profilePic;
  const StudentAvatarGenerator({Key? key, required this.profilePic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      // width: MediaQuery.of(context).size.width*0.0001,
      height: MediaQuery.of(context).size.height * 0.090,
      child: ClipOval(
        child: Image(
          image: Image.memory(const Base64Decoder().convert(profilePic)).image,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
