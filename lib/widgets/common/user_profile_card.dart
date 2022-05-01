import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/database/common/tests.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: testForUserHomeScreen(),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const SizedBox(
            height: 0,
          );
        } else {
          if (snapshot.hasData) {
            return Card(
              color: Colors.purpleAccent,
              elevation: 8.0,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.70,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  // color: Colors.purpleAccent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "UserName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Name of the User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy ').format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0,
            );
          }
        }
      },
    );
  }
}
