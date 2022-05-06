import 'package:flutter/material.dart';
import '../../../services/connection/fetch_leaves.dart';
import '../../../widgets/leave/approvals/head.dart';

class HeadLeaveScreen extends StatelessWidget {
  static const routeName = "/screen-head-leave";
  const HeadLeaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leave'),
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
        child: FutureBuilder(
            future: getFacultyLeaveRequestsFromServerHeadMode(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.hasError ||
                  snapshot.hasData == false ||
                  snapshot.data.isEmpty) {
                return const Text("No Leave Requests");
              } else {
                var leaveRequests = snapshot.data;
                return ApproveLeaveWidgetHead(leaveRequests: leaveRequests);
              }
            }),
      ),
    );
  }
}
