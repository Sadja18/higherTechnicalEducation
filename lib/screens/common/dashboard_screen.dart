// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';
// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../helpers/validators/login_field_validators.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/common/buttons/logout.dart';
import '../../widgets/navigation_buttons/faculty.dart';
import '../../widgets/navigation_buttons/head.dart';
import '../../widgets/navigation_buttons/master.dart';
import '../../widgets/navigation_buttons/nt_staff.dart';
import '../../widgets/navigation_buttons/parent.dart';
import '../../widgets/common/user_profile_card.dart';
import '../../widgets/navigation_buttons/student.dart';
import '../../widgets/dashboard/student.dart';
import '../../helpers/controllers/common/user_session_db_requests.dart';
import '../../services/connection/student_mode_methods.dart';

// import '../../services/database/common/tests.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class DashboardScreen extends StatelessWidget {
  static const routeName = "screen-dashboard";
  const DashboardScreen({Key? key}) : super(key: key);

  Widget navigationButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: FutureBuilder(
          future: whichUserLoggedIn(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else {
              if (snapshot.hasData == false) {
                return const SizedBox(
                  height: 0,
                );
              } else {
                var data = snapshot.data;
                switch (data) {
                  case 6:
                    return const StudentScreenNavigationButtons();
                  case 5:
                    return const ParentScreenNavigationButtons();
                  case 3:
                    return const FacultyScreenNavigationButtons();
                  case 4:
                    return const NtStaffScreenNavigationButtons();
                  case 2:
                    return const HeadScreenNavigationButtons();
                  case 1:
                    return const MasterScreenNavigationButtons();
                  default:
                    return const SizedBox(
                      height: 0,
                    );
                }
              }
            }
          }),
    );
  }

  Widget titleBar() {
    return Container(
      alignment: Alignment.topCenter,
      child: FutureBuilder(
          future: whichUserLoggedIn(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else {
              if (snapshot.hasData == false) {
                return const SizedBox(
                  height: 0,
                );
              } else {
                var data = snapshot.data;
                switch (data) {
                  case "student":
                    return const Text(
                      "Student",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "parent":
                    return const Text(
                      "Parent",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "faculty":
                    return const Text(
                      "Teaching Staff",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "ntStaff":
                    return const Text(
                      "Non-Teaching Staff",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "head":
                    return const Text(
                      "HoD",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "master":
                    return const Text(
                      "HoI",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  default:
                    return const SizedBox(
                      height: 0,
                    );
                }
              }
            }
          }),
    );
  }

  Widget homeHeader() {
    return FutureBuilder(
      future: getLoggedInUserName(),
      builder: (BuildContext ctx, AsyncSnapshot snap) {
        if (snap.hasError == false &&
            snap.hasData == true &&
            snap.data != null &&
            snap.data.isNotEmpty) {
          var records = snap.data;
          var record = records[0];
          var userType = records[1];
          if (kDebugMode) {
            log('hone header records');
            // log(records.toString());
          }
          String designation = "";
          String college = "";
          String deptName = "";
          var profilePicString = record[0]['profilePic'] != null &&
                  record[0]['profilePic'].isNotEmpty
              ? record[0]['profilePic']
              : defaultMasterProfilePic;
          var userName = "";
          switch (userType) {
            case 'student':
              userName = record[0]['studentName'];
              designation = "Course: " + records[2];
              college = records[3].toString();
              break;
            case 'faculty':
              userName = record[0]['teacherName'];
              designation = records[2];
              college = records[3].toString();
              deptName = record[0]['deptName'];
              break;
            case 'head':
              userName = record[0]['teacherName'];
              designation = records[2];
              college = records[3].toString();
              deptName = record[0]['deptName'];
              break;
            case 'master':
              userName = record[0]['headName'];
              designation = records[2];
              // designation = recods[1];
              college = records[3].toString();
              break;
            default:
              userName = "";
          }

          var displayString = userName + ",";
          if (designation != "") {
            displayString = displayString + '\n' + designation + ",";
          }
          if (deptName != "") {
            displayString = displayString + '\n' + deptName + ",";
          }
          if (college != "") {
            displayString = displayString + '\n' + college;
          }

          return SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.99,
            height: MediaQuery.of(ctx).size.height * 0.25,
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.30),
                1: FractionColumnWidth(0.70),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: SizedBox(
                        // decoration: BoxDecoration(
                        //   color: Colors.red,
                        // ),
                        width: MediaQuery.of(ctx).size.width * 0.12,
                        child: ClipOval(
                          child: Image(
                            image: Image.memory(const Base64Decoder()
                                    .convert(profilePicString))
                                .image,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(ctx).size.height * 0.25,
                            width: MediaQuery.of(ctx).size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Welcome, \n' + displayString,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 0,
          );
        }
      },
    );
  }

  Widget rollerWidget(context) {
    // return FutureBuilder(builder: (BuildContext ctx, as))
    // return
    // var someVar = 123 + 12;
    // double overAll = 51;
    return FutureBuilder(
        future: whichUserLoggedIn(),
        builder: (BuildContext ctxt, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (snapshot.hasError ||
                snapshot.hasData != true ||
                snapshot.data == null ||
                snapshot.data == false) {
              return const SizedBox(
                height: 0,
              );
            } else {
              var userType = snapshot.data;
              switch (userType) {
                case 6:
                  return FutureBuilder(
                    future: fetchSemesterAttendanceForCurrentStudent(),
                    builder: (BuildContext c, AsyncSnapshot s) {
                      if (s.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else {
                        if (s.hasError ||
                            s.hasData != true ||
                            s.data == null ||
                            s.data == false ||
                            s.data.isEmpty) {
                          return const SizedBox(
                            height: 0,
                          );
                        } else {
                          var values = s.data;
                          var overall = values['overall'];
                          double overAll = 0;
                          if (overall != null && overall != '') {
                            overAll = double.parse(
                                overall[0].toString().split("%")[0].toString());
                          }
                          // values.removeWhere((key, val){key=='overall'});
                          return Expanded(
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: MediaQuery.of(context).size.height * 0.40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                // color: Colors.blueGrey.shade400,
                                border: Border.all(),
                              ),
                              child: Table(
                                columnWidths: const {
                                  0: FractionColumnWidth(1.00),
                                  // 1: FractionColumnWidth(0.60),
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: overall != null || overall != ""
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Overall Attendance: $overAll %",
                                                  style: const TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: values.keys.toList().length > 1
                                            ? AttendanceSubjectWise(
                                                attendanceMap: values)
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                case 1:
                  // master logged in
                  return FutureBuilder(
                      builder: (BuildContext ctx, AsyncSnapshot snap) {
                    return Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(),
                            alignment: Alignment.center,
                            child: Table(
                              border: TableBorder.all(),
                              columnWidths: const {
                                0: FractionColumnWidth(0.80),
                                1: FractionColumnWidth(0.20),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Pending Leave Requests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          1.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Approved Leave Requests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          0.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Rejected Leave Requests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          0.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Depts Attendance to be taken",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          6.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Depts Attendance pending Sync",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          0.toString(),
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
                    );
                  });
                case 2:
                  return FutureBuilder(
                      builder: (BuildContext ctx, AsyncSnapshot snap) {
                    return Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(),
                            alignment: Alignment.center,
                            child: Table(
                              border: TableBorder.all(),
                              columnWidths: const {
                                0: FractionColumnWidth(0.80),
                                1: FractionColumnWidth(0.20),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Pending Leave Requests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          1.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Approved Leave Requests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          0.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          "Rejected Leave Requests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          0.toString(),
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
                    );
                  });

                case 3:
                  return FutureBuilder(
                      builder: (BuildContext c, AsyncSnapshot s) {
                    var values = {
                      "overall": ["0.63%"]
                    };
                    var overall = values['overall'];
                    double overAll = 0;
                    // ignore: unrelated_type_equality_checks
                    if (overall != null && overall != '') {
                      overAll = double.parse(
                          overall[0].toString().split("%")[0].toString());
                    }
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        // height: MediaQuery.of(context).size.height * 0.20,
                        margin: const EdgeInsets.only(
                          top: 25.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            // color: Colors.blueGrey.shade400,
                            ),
                        child: Table(
                          columnWidths: const {
                            0: FractionColumnWidth(1),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  // ignore: unrelated_type_equality_checks
                                  child: overall != null || overall != ""
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Overall Attendance: ${overAll * 100} %",
                                            style: const TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 0,
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    ;
                  });
                default:
                  return const SizedBox(
                    height: 0,
                  );
              }
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: titleBar(),
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
      ),
      drawer: Container(
        decoration: const BoxDecoration(),
        // alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: statusBarHeight + appBarHeight + 1),
        child: Drawer(
          backgroundColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserProfileCard(),
              navigationButtons(),
              const LogoutButton(),
            ],
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            // color: Colors.blueGrey.shade100,
            ),
        child: Column(
          children: [
            homeHeader(),
            rollerWidget(context),
          ],
        ),
      ),
    );
  }
}
