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
  int recall = 0;

  void deptSelector(int selectionDeptId) {
    setState(() {
      selectedDeptId = selectionDeptId;
      recall = 1;
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
          // ignore: prefer_const_constructors
          bottom: TabBar(
            physics: NeverScrollableScrollPhysics(),
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
                child: const Text("Teaching"),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                alignment: Alignment.center,
                child: const Text("Non-Teaching"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              // decoration: BoxDecoration(color: Colors.amber.shade100),
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          // top: 10.0,
                          ),
                      // width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: DropdownDeptSelector(
                        deptSelector: deptSelector,
                      ),
                    ),
                    (selectedDeptId == 0 && recall == 0)
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
                                  key: ObjectKey(staffData),
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
