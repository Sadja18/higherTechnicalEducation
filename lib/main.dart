// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import './screens/common/no_data_screen.dart';
import './services/database/common/tests.dart';
import './screens/common/test_home.dart';
import './screens/common/home_screen.dart';
import './screens/common/dashboard_screen.dart';
import './screens/leave_screen/student.dart';
import './screens/leave_screen/master.dart';
import './screens/leave_screen/head.dart';
import './screens/attendance/master.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget myWidget(ctx) {
    return FutureBuilder(
        future: testForUserHomeScreen(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const HomeScreen();
          } else {
            if (snapshot.hasData) {
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return const NoDataExists();
              } else {
                if (snapshot.data[0] == 1) {
                  return MasterStaffAttendanceScreen();
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
        TestScreen.routenName: (ctx) => const TestScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        DashboardScreen.routeName: (ctx) => DashboardScreen(),
        StudentLeaveScreen.routeName: (ctx) => StudentLeaveScreen(),
        MasterApproveFacultyLeaveScreen.routeName: (ctx) =>
            MasterApproveFacultyLeaveScreen(),
        HeadLeaveScreen.routeName: (ctx) => HeadLeaveScreen(),
        MasterStaffAttendanceScreen.routeName: (ctx) =>
            MasterStaffAttendanceScreen(),
      },
    );
  }
}
