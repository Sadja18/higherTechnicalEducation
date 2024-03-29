import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../screens/leave_screen/master.dart';
import '../../screens/attendance/master.dart';

class MasterScreenNavigationButtons extends StatelessWidget {
  const MasterScreenNavigationButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (kDebugMode) {
                log('master attendance navigation');
              }
              Navigator.of(context)
                  .pushNamed(MasterStaffAttendanceScreen.routeName);
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
                "Attendance",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(MasterApproveFacultyLeaveScreen.routeName);
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
