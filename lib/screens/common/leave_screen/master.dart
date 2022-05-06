import 'package:flutter/material.dart';
import '../../../widgets/leave/approvals/master.dart';
import '../../../services/connection/fetch_leaves.dart';

class MasterApproveFacultyLeaveScreen extends StatefulWidget {
  static const routeName = "/screen-master-leave-approve";
  const MasterApproveFacultyLeaveScreen({Key? key}) : super(key: key);

  @override
  State<MasterApproveFacultyLeaveScreen> createState() =>
      _MasterApproveFacultyLeaveScreenState();
}

class _MasterApproveFacultyLeaveScreenState
    extends State<MasterApproveFacultyLeaveScreen> {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Approve Leaves',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Container(
        decoration: const BoxDecoration(),
        child: FutureBuilder(
          future: getFacultyLeaveRequestsFromServerMasterMode(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError ||
                snapshot.hasData == false ||
                snapshot.data.isEmpty) {
              return const SizedBox(
                child: Text("No Leave Requests"),
              );
            } else {
              var leaveRequests = snapshot.data;
              return MasterLeaveApproveTableWidget(
                  leaveRequests: leaveRequests);
            }
          },
        ),
      ),
    );
  }
}
