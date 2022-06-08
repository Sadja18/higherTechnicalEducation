// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './screens/common/no_data_screen.dart';
// import './services/database/common/tests.dart';
import './screens/common/test_home.dart';
import './screens/common/home_screen.dart';
import './screens/common/dashboard_screen.dart';

import './screens/leave_screen/student.dart';
import './screens/leave_screen/master.dart';

import './screens/leave_screen/head.dart';
import './screens/attendance/master.dart';

import './screens/leave_screen/faculty.dart';
import './screens/attendance/faculty.dart';
import './helpers/controllers/common/user_session_db_requests.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget myWidget(ctx) {
    return FutureBuilder(
        future: whichUserLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (kDebugMode) {
            log('errir my widget');
            log(snapshot.data.toString());
          }
          if (snapshot.hasError) {
            return const HomeScreen();
          } else {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return const NoDataExists();
              } else {
                if ([1, 2, 3, 4, 5, 6].contains(snapshot.data)) {
                  // return DashboardScreen();
                  return HeadLeaveScreen();
                  // ;
                } else {
                  return const TestScreen();
                }
              }
            } else {
              return const HomeScreen();
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTE',
      theme: ThemeData(
        primaryColor: Colors.purpleAccent,
        fontFamily: 'Poppins',
        backgroundColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.20,
              fontSizeDelta: 0.5,
              fontFamily: 'Poppins',
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => myWidget(ctx),
        NoDataExists.routeName: (ctx) => const NoDataExists(),
        TestScreen.routeName: (ctx) => const TestScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        DashboardScreen.routeName: (ctx) => DashboardScreen(),
        StudentLeaveScreen.routeName: (ctx) => StudentLeaveScreen(),
        MasterApproveFacultyLeaveScreen.routeName: (ctx) =>
            MasterApproveFacultyLeaveScreen(),
        HeadLeaveScreen.routeName: (ctx) => HeadLeaveScreen(),
        MasterStaffAttendanceScreen.routeName: (ctx) =>
            MasterStaffAttendanceScreen(),
        FacultyLeaveScreen.routeName: (ctx) => FacultyLeaveScreen(),
        AttendanceScreenFacultyMode.routeName: (ctx) =>
            AttendanceScreenFacultyMode(),
        HeadModeApproveStudentLeave.routeName: (ctx) =>
            HeadModeApproveStudentLeave(),
        HeadModeApproveFacultyLeave.routeName: (ctx) =>
            HeadModeApproveFacultyLeave(),
        HeadModeApproveNtStaffLeave.routeName: (ctx) =>
            HeadModeApproveNtStaffLeave(),
      },
    );
  }
}
