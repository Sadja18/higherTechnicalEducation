import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../screens/leave_screen/student.dart';
import '../../services/connection/student_mode_methods.dart';

class StudentScreenNavigationButtons extends StatefulWidget {
  const StudentScreenNavigationButtons({Key? key}) : super(key: key);

  @override
  State<StudentScreenNavigationButtons> createState() =>
      _StudentScreenNavigationButtonsState();
}

class _StudentScreenNavigationButtonsState
    extends State<StudentScreenNavigationButtons> {
  void showUploadDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext _) {
          return AlertDialog(
            title: const Text("Uploading"),
            content: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("Upload in Progress."),
                  Text("Please do not close the app or the internet"),
                  CircularProgressIndicator.adaptive(),
                ],
              ),
            ),
          );
        });
    await uploadStudentLeaveRequest();
    Navigator.of(context).pop();
    return showDialog(
        context: context,
        builder: (BuildContext _) {
          return const AlertDialog(
            title: Text("Uploading"),
            content: Text("Upload Complete"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // InkWell(
          //   onTap: () {
          //     if (kDebugMode) {
          //       print("Navigate to Time Table screen");
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
          //       "Time Table",
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
          FutureBuilder(
            // future: isOnline(),
            future: isStudentServerReachable(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 0,
                );
              } else {
                if (kDebugMode) {
                  log(snapshot.data.toString());
                }
                if (snapshot.hasError ||
                    snapshot.hasData != true ||
                    snapshot.data == null ||
                    snapshot.data == 0) {
                  return const SizedBox(
                    height: 0,
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      if (kDebugMode) {
                        print("Initiate upload of leave request");
                      }
                      showUploadDialog();
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
                        "Upload to Server",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
