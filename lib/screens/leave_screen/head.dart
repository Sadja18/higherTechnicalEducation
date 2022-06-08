import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/connection/fetch_leaves.dart';
import '../../../widgets/leave/approvals/head.dart';

class HeadLeaveScreen extends StatefulWidget {
  static const routeName = "/head-mode-leave-screen";
  const HeadLeaveScreen({Key? key}) : super(key: key);

  @override
  State<HeadLeaveScreen> createState() => _HeadLeaveScreenState();
}

class _HeadLeaveScreenState extends State<HeadLeaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Approve Leave'),
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xfff21bce),
                Color(0xff826cf0),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  log("message: switch to student approve requests screen");
                }
                Navigator.of(context)
                    .pushNamed(HeadModeApproveStudentLeave.routeName);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.purpleAccent.shade100,
                ),
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.25,
                child: const Text(
                  'Student',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  log("message: switch to teaching staff approve requests screen");
                }
                Navigator.of(context)
                    .pushNamed(HeadModeApproveFacultyLeave.routeName);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.purpleAccent.shade100,
                ),
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.25,
                child: const Text(
                  'Teaching',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  log("message: switch to non teaching staff approve requests screen");
                }
                Navigator.of(context)
                    .pushNamed(HeadModeApproveNtStaffLeave.routeName);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.purpleAccent.shade100,
                ),
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.25,
                child: const Text(
                  'Non-Teaching',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeadModeApproveStudentLeave extends StatefulWidget {
  static const routeName = "/head-mode-approve-leave-student";
  const HeadModeApproveStudentLeave({Key? key}) : super(key: key);

  @override
  State<HeadModeApproveStudentLeave> createState() =>
      _HeadModeApproveStudentLeaveState();
}

class _HeadModeApproveStudentLeaveState
    extends State<HeadModeApproveStudentLeave> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Approve Leave'),
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfff21bce),
                  Color(0xff826cf0),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
          ),
          child: FutureBuilder(
            future: getStudentLeaveRequestsFromServerHeadMode(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (kDebugMode) {
                log('fetch student leaves');
                log(snapshot.hasData.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: const CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError ||
                    snapshot.hasData != true ||
                    snapshot.data == null ||
                    snapshot.data == false ||
                    snapshot.data.isEmpty) {
                  return const Center(
                    child: Text("No pending student leave request"),
                  );
                } else {
                  var studentLeaveRequests = snapshot.data;

                  return ApproveStudentLeaveHeadWidget(
                    leaveRequests: studentLeaveRequests,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class HeadModeApproveFacultyLeave extends StatefulWidget {
  static const routeName = "/head-mode-approve-leave-faculty";

  const HeadModeApproveFacultyLeave({Key? key}) : super(key: key);

  @override
  State<HeadModeApproveFacultyLeave> createState() =>
      _HeadModeApproveFacultyLeaveState();
}

class _HeadModeApproveFacultyLeaveState
    extends State<HeadModeApproveFacultyLeave> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Approve Leave'),
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfff21bce),
                  Color(0xff826cf0),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              // color: Colors.green,
              ),
          child: FutureBuilder(
            future: getFacultyLeaveRequestsFromServerHeadMode(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              } else if (snapshot.hasError ||
                  snapshot.hasData == false ||
                  snapshot.data.isEmpty) {
                return const Center(
                  child: Text("No Pending Leave Requests"),
                );
              } else {
                var leaveRequests = snapshot.data;
                if (leaveRequests.isNotEmpty) {
                  // print("faculty leaves");
                  if (kDebugMode) {
                    log("faculty leabcehvaskjeraavb,jervh");
                    // log(leaveRequests.toString());
                  }
                }
                return ApproveLeaveWidgetHead(
                  leaveRequests: leaveRequests,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class HeadModeApproveNtStaffLeave extends StatefulWidget {
  static const routeName = "/head-mode-approve-leave-ntStaff";

  const HeadModeApproveNtStaffLeave({Key? key}) : super(key: key);

  @override
  State<HeadModeApproveNtStaffLeave> createState() =>
      _HeadModeApproveNtStaffLeaveState();
}

class _HeadModeApproveNtStaffLeaveState
    extends State<HeadModeApproveNtStaffLeave> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Approve Leave'),
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfff21bce),
                  Color(0xff826cf0),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: const Text("No Pending leave Requests Found"),
        ),
      ),
    );
  }
}
