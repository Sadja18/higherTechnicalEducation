import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../widgets/leave/approvals/master.dart';
import '../../../services/connection/fetch_leaves.dart';
import '../../widgets/common/dropdowns/dropdown_dept_selector.dart';

class MasterApproveFacultyLeaveScreen extends StatefulWidget {
  static const routeName = "/screen-master-leave-approve";
  const MasterApproveFacultyLeaveScreen({Key? key}) : super(key: key);

  @override
  State<MasterApproveFacultyLeaveScreen> createState() =>
      _MasterApproveFacultyLeaveScreenState();
}

class _MasterApproveFacultyLeaveScreenState
    extends State<MasterApproveFacultyLeaveScreen> {
  late int selectedDeptId = 0;

  void deptSelector(int selectionDeptId) {
    setState(() {
      selectedDeptId = selectionDeptId;
    });
    if (kDebugMode) {
      log("selection: $selectedDeptId");
      log("selected: $selectedDeptId");
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            physics: const NeverScrollableScrollPhysics(),
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 82, 99, 255),
            ),
            tabs: [
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                alignment: Alignment.center,
                child: const Text('Teaching'),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                alignment: Alignment.center,
                child: const Text('Non-Teaching'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  DropdownDeptSelector(
                    deptSelector: deptSelector,
                  ),
                  (selectedDeptId == 0)
                      ? const SizedBox(
                          height: 0,
                        )
                      : FutureBuilder(
                          future: getFacultyLeaveRequestsFromServerMasterMode(
                              selectedDeptId),
                          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (snapshot.hasError ||
                                snapshot.hasData == false ||
                                snapshot.data.isEmpty) {
                              return const SizedBox(
                                child: Text("No Leave Requests"),
                              );
                            } else {
                              var leaveRequests = snapshot.data;
                              return MasterLeaveApproveTableWidget(
                                leaveRequests: leaveRequests,
                              );
                            }
                          },
                        ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text("No pending leave requests"),
            ),
          ],
        ),
      ),
    );
  }
}
