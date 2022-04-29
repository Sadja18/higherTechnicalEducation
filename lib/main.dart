import 'package:flutter/material.dart';
import './screens/common/which_user.dart';
import './screens/common/no_data_screen.dart';
import './services/database/common/tests.dart';
import './screens/common/test_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget myWidget(ctx) {
    return FutureBuilder(
        future: testForUserHomeScreen(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const NoDataExists();
          } else {
            if (snapshot.hasData) {
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return const NoDataExists();
              } else {
                if (snapshot.data[0] == 1) {
                  return const WhichUser();
                } else {
                  return const TestScreen();
                }
              }
            } else {
              return const NoDataExists();
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const WhichUser(),
        NoDataExists.routeName: (ctx) => const NoDataExists(),
        TestScreen.routenName: (ctx) => const TestScreen(),
      },
    );
  }
}
