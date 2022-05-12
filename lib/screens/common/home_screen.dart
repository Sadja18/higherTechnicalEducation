import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widgets/common/dropdowns/dropdown_user_type.dart';
import '../../widgets/common/login.dart';

const Map<String, String> userTypes = {
  "Head of Institution": "master",
  "Head of Department": "head",
  "Teaching Staff": "faculty",
  "Non-Teaching Staff": "ntStaff",
  "Parent": "parent",
  "Student": "student"
};

class HomeScreen extends StatefulWidget {
  static const routeName = "screen-home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userType = "faculty";
  void userTypeSelector(String selectedUserType) {
    if (kDebugMode) {
      print(selectedUserType);
    }
    if (userTypes[selectedUserType] != null) {
      setState(() {
        userType = userTypes[selectedUserType]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Login",
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
        alignment: Alignment.topCenter,
        // dec
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 241, 234, 234),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownUserType(userTypeSelector: userTypeSelector),
              (userType == "" || userType.isEmpty)
                  ? const SizedBox(
                      height: 0,
                    )
                  : UserLoginWidget(
                      userType: userType,
                      key: ObjectKey(userType),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
