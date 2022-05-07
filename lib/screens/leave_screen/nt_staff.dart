// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../widgets/leave/apply/form_widget.dart';

class NtStaffLeaveScreen extends StatelessWidget {
  static const routeName = "/screen-ntstaff-leave";
  const NtStaffLeaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
        body: TabBarView(
          children: [
            Container(
              alignment: Alignment.center,
              child: ApplyForLeaveWidget(userType: "ntStaff"),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text("Calendar view NtStaff leave"),
            ),
          ],
        ),
      ),
    );
  }
}
