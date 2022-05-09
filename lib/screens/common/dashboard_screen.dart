// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/buttons/logout.dart';
import '../../widgets/navigation_buttons/faculty.dart';
import '../../widgets/navigation_buttons/head.dart';
import '../../widgets/navigation_buttons/master.dart';
import '../../widgets/navigation_buttons/nt_staff.dart';
import '../../widgets/navigation_buttons/parent.dart';
import '../../widgets/common/user_profile_card.dart';
import '../../widgets/navigation_buttons/student.dart';
import '../../helpers/controllers/common/user_session_db_requests.dart';
import '../../services/database/common/tests.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "screen-dashboard";
  const DashboardScreen({Key? key}) : super(key: key);

  Widget navigationButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: FutureBuilder(
          future: whichUserLoggedIn(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else {
              if (snapshot.hasData == false) {
                return const SizedBox(
                  height: 0,
                );
              } else {
                var data = snapshot.data;
                switch (data) {
                  case 6:
                    return const StudentScreenNavigationButtons();
                  case 5:
                    return const ParentScreenNavigationButtons();
                  case 3:
                    return const FacultyScreenNavigationButtons();
                  case 4:
                    return const NtStaffScreenNavigationButtons();
                  case 2:
                    return const HeadScreenNavigationButtons();
                  case 1:
                    return const MasterScreenNavigationButtons();
                  default:
                    return const SizedBox(
                      height: 0,
                    );
                }
              }
            }
          }),
    );
  }

  Widget titleBar() {
    return Container(
      alignment: Alignment.topCenter,
      child: FutureBuilder(
          future: whichUserLoggedIn(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else {
              if (snapshot.hasData == false) {
                return const SizedBox(
                  height: 0,
                );
              } else {
                var data = snapshot.data;
                switch (data) {
                  case "student":
                    return const Text(
                      "Student",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "parent":
                    return const Text(
                      "Parent",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "faculty":
                    return const Text(
                      "Teaching Staff",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "ntStaff":
                    return const Text(
                      "Non-Teaching Staff",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "head":
                    return const Text(
                      "HoD",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  case "master":
                    return const Text(
                      "HoI",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  default:
                    return const SizedBox(
                      height: 0,
                    );
                }
              }
            }
          }),
    );
  }

  Widget homeHeader() {
    return FutureBuilder(
        future: getLoggedInUserName(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          // if(kDebugMode){}
          if (snapshot.hasError ||
              snapshot.hasData == false ||
              snapshot.data.isEmpty ||
              snapshot.data == "") {
            return const SizedBox(
              height: 0,
            );
          } else {
            var nameOfUser = snapshot.data;
            return Text('Welcome $nameOfUser',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
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
      drawer: Container(
        decoration: const BoxDecoration(),
        // alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: statusBarHeight + appBarHeight + 1),
        child: Drawer(
          backgroundColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserProfileCard(),
              navigationButtons(),
              const LogoutButton(),
            ],
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            homeHeader(),
            // OutlinedButton(
            //   onPressed: () {
            //     readTablesInDB();
            //   },
            //   child: const Text("Test"),
            // ),
          ],
        ),
      ),
    );
  }
}
