import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/connection/fetch_leaves.dart';
import '../../../widgets/leave/approvals/head.dart';

class HeadLeaveScreen extends StatelessWidget {
  static const routeName = "/screen-head-leave";
  const HeadLeaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
          bottom: TabBar(
            tabs: [
              RichText(
                text: const TextSpan(
                  text: 'Student',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Teacher',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Staff',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Text("Some data"),
              // FutureBuilder(
              //     future: getStudentLeaveRequestsFromServerHeadMode(),
              //     builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              //       if (kDebugMode) {
              //         log('fetch student leaves');
              //         log(snapshot.hasData.toString());
              //       }
              //       if (snapshot.hasError) {
              //         return const SizedBox(
              //           height: 0,
              //         );
              //       } else {
              //         if (snapshot.hasData) {
              //           if (snapshot.data == null || snapshot.data.isEmpty) {
              //             return const SizedBox(
              //               height: 0,
              //             );
              //           } else {
              //             var studentLeaveRequests = snapshot.data;
              //             return Text(studentLeaveRequests.toString());
              //           }
              //         } else {
              //           return const SizedBox(
              //             height: 0,
              //           );
              //         }
              //       }
              //     }),
            ),
            Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                  future: getFacultyLeaveRequestsFromServerHeadMode(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.hasError ||
                        snapshot.hasData == false ||
                        snapshot.data.isEmpty) {
                      return const Text("No Leave Requests");
                    } else {
                      var leaveRequests = snapshot.data;
                      if (leaveRequests.isNotEmpty && kDebugMode) {
                        print("faculty leaves");
                      }
                      return ApproveLeaveWidgetHead(
                          leaveRequests: leaveRequests);
                    }
                  }),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: const Text('Staff Leave Approve Data'),
            ),
          ],
        ),
      ),
    );
    //   return Scaffold(
    //     appBar: AppBar(
    //       centerTitle: true,
    //       title: const Text('Approve Leave'),
    //       backgroundColor: Theme.of(context).primaryColor,
    //       flexibleSpace: Container(
    //         decoration: const BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [
    //               Color(0xfff21bce),
    //               Color(0xff826cf0),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     body: Container(
    //       alignment: Alignment.center,
    //       child: FutureBuilder(
    //           future: getFacultyLeaveRequestsFromServerHeadMode(),
    //           builder: (BuildContext ctx, AsyncSnapshot snapshot) {
    //             if (snapshot.hasError ||
    //                 snapshot.hasData == false ||
    //                 snapshot.data.isEmpty) {
    //               return const Text("No Leave Requests");
    //             } else {
    //               var leaveRequests = snapshot.data;
    //               return ApproveLeaveWidgetHead(leaveRequests: leaveRequests);
    //             }
    //           }),
    //     ),
    //   );
  }
}
