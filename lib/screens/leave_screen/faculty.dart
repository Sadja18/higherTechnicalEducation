import 'package:flutter/material.dart';
import '../../widgets/leave/apply/form_widget.dart';
import '../../widgets/leave/view/faculty_view_applied_leave.dart';

class FacultyLeaveScreen extends StatelessWidget {
  static const routeName = "/screen-faculty-leave";
  const FacultyLeaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: const Text(
            "Leave",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
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
            tabs: [
              Tab(
                child: Row(
                  children: const [
                    Icon(
                      Icons.create_outlined,
                      semanticLabel: 'Apply for leave',
                      size: 40,
                    ),
                    Text(
                      'Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: const [
                    Icon(
                      Icons.view_list_outlined,
                      semanticLabel: 'View leave request status',
                      size: 40,
                    ),
                    Text(
                      'View',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        endDrawer: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.78,
          margin: EdgeInsets.only(top: statusBarHeight + appBarHeight + 1),
          height: MediaQuery.of(context).size.height * 0.25,
          child: Drawer(
            backgroundColor: Colors.white,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FractionColumnWidth(0.70),
                1: FractionColumnWidth(0.25),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        child: const Text("Pending Approval by HoD"),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            14.0,
                          ),
                          color: Colors.blue,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const Text("     "),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(),
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: const Text("Pending Approval by HoI"),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            14.0,
                          ),
                          color: Colors.purple,
                        ),
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const Text("     "),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        decoration: const BoxDecoration(),
                        width: MediaQuery.of(context).size.width,
                        child: const Text("Approved by HoI"),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            14.0,
                          ),
                          color: Colors.green,
                        ),
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const Text("     "),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        decoration: const BoxDecoration(),
                        width: MediaQuery.of(context).size.width,
                        child: const Text("Rejected"),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            14.0,
                          ),
                          color: Colors.red,
                        ),
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const Text("     "),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              alignment: Alignment.center,
              child: const ApplyForLeaveWidget(userType: 'faculty'),
            ),
            FutureBuilderForFetchFacultyLeave(),
          ],
        ),
      ),
    );
  }
}
