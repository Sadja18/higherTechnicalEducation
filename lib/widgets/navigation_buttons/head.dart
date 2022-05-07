import 'package:flutter/material.dart';
import '../../screens/leave_screen/head.dart';

class HeadScreenNavigationButtons extends StatelessWidget {
  const HeadScreenNavigationButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.05,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: const Text(
                "Attendance",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(HeadLeaveScreen.routeName);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.05,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: const Text(
                "Leave",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
