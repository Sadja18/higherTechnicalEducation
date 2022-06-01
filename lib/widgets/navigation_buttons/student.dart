import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../screens/leave_screen/student.dart';

class StudentScreenNavigationButtons extends StatelessWidget {
  const StudentScreenNavigationButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (kDebugMode) {
                print("Navigate to Time Table screen");
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.05,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: const Text(
                "Time Table",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     if (kDebugMode) {
          //       print("Navigate to attendance screen");
          //     }
          //   },
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.60,
          //     height: MediaQuery.of(context).size.height * 0.05,
          //     margin: const EdgeInsets.symmetric(
          //       vertical: 4.0,
          //     ),
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //       color: Colors.purpleAccent,
          //       borderRadius: BorderRadius.circular(
          //         10.0,
          //       ),
          //     ),
          //     child: const Text(
          //       "Attendance",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              if (kDebugMode) {
                print("Navigate to Leave screen");
              }
              Navigator.of(context).pushNamed(StudentLeaveScreen.routeName);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.05,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: const Text(
                "Leave",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
