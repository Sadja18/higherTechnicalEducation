import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../helpers/controllers/common/user_session_db_requests.dart';
import '../../../screens/common/home_screen.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  void logOutUser() async {
    if (kDebugMode) {
      await endUserSession();
      print("User Logged Out");
      print("Re-Direct to Login Screen");
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        width: MediaQuery.of(context).size.width * 0.60,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
