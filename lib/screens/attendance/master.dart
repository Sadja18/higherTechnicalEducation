import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/connection/fetch_faculty.dart';
import '../../widgets/common/dropdowns/dropdown_dept_selector.dart';
import '../../widgets/attendance/edit/master.dart';

class MasterStaffAttendanceScreen extends StatefulWidget {
  static const routeName = "/screen-master-attendance";
  const MasterStaffAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<MasterStaffAttendanceScreen> createState() =>
      _MasterStaffAttendanceScreenState();
}

class _MasterStaffAttendanceScreenState
    extends State<MasterStaffAttendanceScreen> {
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

  Widget titleBar() {
    return const Text(
      "Attendance",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: titleBar(),
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
          bottom: const TabBar(
            tabs: [Text("Teaching"), Text("Non-Teaching")],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.amber.shade100),
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownDeptSelector(
                      deptSelector: deptSelector,
                    ),
                    (selectedDeptId == 0)
                        ? const SizedBox(
                            height: 0,
                          )
                        : FutureBuilder(
                            future: getFacultyDataFromDatabaseMasterMode(
                                selectedDeptId),
                            builder:
                                (BuildContext ctx, AsyncSnapshot snapshot) {
                              if (snapshot.hasError ||
                                  snapshot.hasData == false ||
                                  snapshot.data == null ||
                                  snapshot.data.isEmpty) {
                                return const SizedBox(
                                  child: Text("NO Staff members data found"),
                                );
                              } else {
                                var staffData = snapshot.data;
                                if (kDebugMode) {
                                  // log(staffData.toString());
                                }
                                return StaffAttendanceWidget(
                                  members: staffData,
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text("Non-Teaching staff profiles not found"),
            ),
          ],
        ),
      ),
    );
  }
}
