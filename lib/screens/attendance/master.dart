import 'package:flutter/material.dart';
import '../../services/connection/fetch_faculty.dart';
import '../../widgets/common/dropdown_dept_selector.dart';

class MasterStaffAttendanceScreen extends StatefulWidget {
  static const routeName = "/screen-master-attendance";
  const MasterStaffAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<MasterStaffAttendanceScreen> createState() =>
      _MasterStaffAttendanceScreenState();
}

class _MasterStaffAttendanceScreenState
    extends State<MasterStaffAttendanceScreen> {
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
    return Scaffold(
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.70,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DropdownDeptSelector(),
              FutureBuilder(
                future: getFacultyDataFromServerMasterMode(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (snapshot.hasError ||
                      snapshot.hasData == false ||
                      snapshot.data == null ||
                      snapshot.data.isEmpty) {
                    return const SizedBox(
                      child: Text("NO Staff members data found"),
                    );
                  } else {
                    var staffData = snapshot.data;
                    return Text("staffData.toString()");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
