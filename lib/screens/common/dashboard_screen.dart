// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

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
        future: getUserProfilePic(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasError == false &&
              snapshot.hasData == true &&
              snapshot.data != null &&
              snapshot.data != "") {
            // there was a profile pic
            var profilePicString = snapshot.data;
            return FutureBuilder(
              future: getLoggedInUserName(),
              builder: (BuildContext ctx, AsyncSnapshot snap) {
                if (snap.hasError == false &&
                    snap.hasData == true &&
                    snap.data != null &&
                    snap.data != "") {
                  return Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FractionColumnWidth(0.50),
                      1: FractionColumnWidth(0.50),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Image(
                              image: Image.memory(const Base64Decoder()
                                      .convert(profilePicString))
                                  .image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          TableCell(
                            child: Text(
                              'Welcome, \n ${snap.data}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox(
                    height: 0,
                  );
                }
              },
            );
          } else {
            // there was not a profile pic
            return FutureBuilder(
              future: getLoggedInUserName(),
              builder: (BuildContext ctx, AsyncSnapshot snap) {
                if (snap.hasError == false &&
                    snap.hasData == true &&
                    snap.data != null &&
                    snap.data != "") {
                  return Text(
                    'Welcome, \n ${snap.data}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 0,
                  );
                }
              },
            );
          }
        });
    // return FutureBuilder(
    //     future: getLoggedInUserName(),
    //     builder: (BuildContext ctx, AsyncSnapshot snapshot) {
    //       // if(kDebugMode){}
    //       if (snapshot.hasError ||
    //           snapshot.hasData == false ||
    //           snapshot.data.isEmpty ||
    //           snapshot.data == "") {
    //         return const SizedBox(
    //           height: 0,
    //         );
    //       } else {
    //         var nameOfUser = snapshot.data;
    //         if (kDebugMode) {
    //           log('nameOfUser $nameOfUser');
    //         }
    //         return Container(
    //           alignment: Alignment.topCenter,
    //           decoration: const BoxDecoration(
    //             color: Colors.deepPurpleAccent,
    //           ),
    //           child: Table(
    //             columnWidths: <int, TableColumnWidth>{
    //               0: nameOfUser == "" || nameOfUser == null
    //                   ? const FractionColumnWidth(0.00)
    //                   : const FractionColumnWidth(0.50),
    //               1: nameOfUser == "" || nameOfUser == null
    //                   ? const FractionColumnWidth(1.00)
    //                   : const FractionColumnWidth(0.50)
    //             },
    //             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //             children: [
    //               TableRow(children: [
    //                 TableCell(
    //                   child: FutureBuilder(
    //                       future: getUserProfilePic(),
    //                       builder: (BuildContext ctx, AsyncSnapshot snapshot) {
    //                         if (snapshot.hasData &&
    //                             snapshot.data != null &&
    //                             snapshot.data != "") {
    //                           var profilePicString = snapshot.data;
    //                           return Container(
    //                             decoration: const BoxDecoration(),
    //                             child: Image(
    //                               image: Image.memory(const Base64Decoder()
    //                                       .convert(profilePicString))
    //                                   .image,
    //                               fit: BoxFit.fill,
    //                             ),
    //                           );
    //                         }
    //                         return const SizedBox(
    //                           height: 0,
    //                         );
    //                       }),
    //                 ),
    //                 TableCell(
    //                   child: Text(
    //                     'Welcome, \n $nameOfUser',
    //                     style: const TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ]),
    //             ],
    //           ),
    //         );
    //       }
    //     });
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
