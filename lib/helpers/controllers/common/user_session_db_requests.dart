import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../services/database/handler.dart';

const Map<int, Object> userTypesIntKeys = {
  6: "student",
  5: "parent",
  4: "ntStaff",
  3: "faculty",
  2: "head",
  1: "master"
};

/// return value 0 represents no logged in user
/// return value -1 represents multiple user sessions [in which case logout all of the user];
/// return value of 1 or a dictionary value of user data represents, a valid login session
Future<dynamic> isLoggedInSession() async {
  try {
    var resultList = await DBProvider.db.isSomeUserLoggedIn();

    if (resultList.length <= 0) {
      return 0;
    } else {
      if (resultList.length == 1) {
        var userDetails = resultList[0];

        if (userDetails['loginStatus'] == 1) {
          return userDetails;
        } else {
          return 0;
        }
      } else {
        return -1;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log("error checking user login session");
      log(e.toString());
    }
  }
}

Future<void> endUserSession() async {
  try {
    await DBProvider.db.forceLogOutAllUsers();
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}

/// it will return user type
Future<dynamic> whichUserLoggedIn() async {
  try {
    var loggedInUserType = await DBProvider.db.dynamicRead(
        "SELECT userType FROM UserLoginSession WHERE loginStatus=1", []);
    if (kDebugMode) {
      log("user type which user ");
      log(loggedInUserType.toString());
    }
    if (loggedInUserType.isNotEmpty) {
      var userTypeIntKey = loggedInUserType[0]['userType'];
      if (kDebugMode) {
        print('gt');
        print(loggedInUserType[0]['userType']);
      }
      if (userTypeIntKey != null) {
        return userTypeIntKey;
      }
    }
    // return "master";
    // return "head";
    // return "faculty";
    // return "ntStaff";
    // return "parent";
    // return "student";
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}

Future<dynamic> getLoggedInUserName() async {
  try {
    var query =
        "SELECT userType, userId FROM UserLoginSession WHERE loginStatus=1;";
    var params = [];

    var userData = await DBProvider.db.dynamicRead(query, params);
    if (kDebugMode) {
      log("get loogged i  user");
      log(userData.toString());
    }

    if (userData.isNotEmpty) {
      if (kDebugMode) {
        // log(userData.toString());
        log('here');
        log(userData[0]['userId'].runtimeType.toString());
        log(userData[0]['userType'].runtimeType.toString());
      }
      var user = userData[0];
      var userId = user['userId'];
      var nameOfUser = "";

      switch (user['userType']) {
        case 1:
          var val = await DBProvider.db.dynamicRead(
              "SELECT headName FROM Master "
              "WHERE userId = "
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          nameOfUser = val[0]['headName'];
          return nameOfUser;
        // case "1":
        //   return "master";
        case 2:
          var val = await DBProvider.db.dynamicRead(
              "SELECT teacherName FROM Head "
              "WHERE userId="
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          nameOfUser = val[0]['teacherName'];
          return nameOfUser;
        // case "2":
        //   return "head";
        case 3:
          var val = await DBProvider.db.dynamicRead(
              "SELECT teacherName FROM Faculty "
              "WHERE userId="
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          nameOfUser = val[0]['teacherName'];
          return nameOfUser;
        // case "3":
        //   return "faculty";
        case 4:
          return "ntStaff";
        // case "4":
        //   return "ntStaff";
        case 5:
          var val = await DBProvider.db.dynamicRead(
              "SELECT parentName FROM Parent WHERE "
              "userId = "
              "(SELECT userId FROM UserLoginSession WHERE loginStatus = 1);",
              []);
          nameOfUser = val[0]['parentName'];
          return nameOfUser;
        // case "5":
        //   return "parent";
        case 6:
          var val = await DBProvider.db.dynamicRead(
              "SELECT studentName FROM Student ",
              // "WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1;)",
              []);
          if (kDebugMode) {
            log(val.toString());
          }
          nameOfUser = val[0]['studentName'];
          return nameOfUser;
        // case "6":
        //   var val = await DBProvider.db.dynamicRead(
        //     "SELECT studentName FROM Student WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1;)",
        //     []);
        // nameOfUser = val[0]['studentName'];
        // if (kDebugMode) {
        //   log(val.toString());
        // }
        // return nameOfUser;
        default:
          return "";
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('username db fetch error');
      log(e.runtimeType.toString());
      log(e.toString());
    }
  }
}
