// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../widgets/common/buttons/logout.dart';
import '../../widgets/common/user_profile_card.dart';
import '../../widgets/navigation_buttons/student.dart';
import '../../helpers/controllers/common/user_session_db_requests.dart';

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
                  child: Text("Student data nope"),
                );
              } else {
                var data = snapshot.data;
                switch (data) {
                  case "student":
                    return const StudentScreenNavigationButtons();

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

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
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
        child: const Text("Welcome User"),
      ),
    );
  }
}
