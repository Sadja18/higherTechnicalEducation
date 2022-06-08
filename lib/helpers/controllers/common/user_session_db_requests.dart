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
        "SELECT userType FROM UserLoginSession WHERE loginStatus=1;", []);
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
      log("get loogged in user");
      log(userData.runtimeType.toString());
    }

    if (userData.isNotEmpty) {
      if (kDebugMode) {
        // log(userData.toString());
        log('here');
        log(userData[0].toString());
        // log(userData[0]['userType'].runtimeType.toString());
      }
      var user = userData[0];
      // var nameOfUser = "";

      switch (user['userType']) {
        case 1:
          var val = await DBProvider.db.dynamicRead(
              "SELECT headName, profilePic, collegeId FROM Master "
              "WHERE userId = "
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          if (val != null && val.isNotEmpty) {
            var param = [val[0]['collegeId']];
            var dbQuery = "SELECT collegeName FROM College WHERE collegeId=?";
            var collegeNames = await DBProvider.db.dynamicRead(dbQuery, param);
            var collegeName = collegeNames[0]['collegeName'];

            String designation = "HoI";
            if (kDebugMode) {
              log("select from master");
              // log(val.toString());
            }
            return [val, 'master', designation, collegeName];
          } else {
            break;
          }
        // case "1":
        //   return "master";
        case 2:
          var val = await DBProvider.db.dynamicRead(
              "SELECT profilePic, teacherName, collegeId, deptName FROM Head "
              "WHERE userId="
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          if (kDebugMode) {
            log("head");
            // log(val.toString());
            log("haed");
          }
          if (val != null && val.isNotEmpty) {
            var param = [val[0]['collegeId']];
            var dbQuery = "SELECT collegeName FROM College WHERE collegeId=?";
            var collegeNames = await DBProvider.db.dynamicRead(dbQuery, param);
            if (kDebugMode) {
              log('cl');
              // log(collegeNames.toString());
              log('ccl');
            }
            var collegeName = collegeNames[0]['collegeName'];

            String designation = "HoD";
            return [val, 'head', designation, collegeName];
          } else {
            break;
          }
        // case "2":
        //   return "head";
        case 3:
          var val = await DBProvider.db.dynamicRead(
              "SELECT teacherName, profilePic, collegeId, deptName FROM Faculty "
              "WHERE userId="
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          if (val != null && val.isNotEmpty) {
            var param = [val[0]['collegeId']];

            var dbQuery = "SELECT collegeName FROM College WHERE collegeId=?";
            var collegeNames = await DBProvider.db.dynamicRead(dbQuery, param);
            var collegeName = collegeNames[0]['collegeName'];

            String designation = "Teaching Staff";
            return [val, 'faculty', designation, collegeName];
            // return [val, 'faculty'];
          } else {
            break;
          }
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
          if (val != null && val.isNotEmpty) {
            // val[0]['userType'] = 'parent';
            return [val, 'parent'];
          } else {
            break;
          }
        // case "5":
        //   return "parent";
        case 6:
          var val = await DBProvider.db.dynamicRead(
              "SELECT studentName, profilePic, courseId, collegeId FROM Student "
              "WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1);",
              []);
          if (kDebugMode) {
            // log(val.toString());
          }
          if (val != null && val.isNotEmpty) {
            var param = [val[0]['collegeId']];

            var dbQuery = "SELECT collegeName FROM College WHERE collegeId=?";
            var collegeNames = await DBProvider.db.dynamicRead(dbQuery, param);
            var collegeName = collegeNames[0]['collegeName'];
            var courseName = await DBProvider.db.dynamicRead(
                "SELECT courseName "
                "FROM Course "
                "WHERE courseId=?",
                [val[0]['courseId']]);
            String designation = courseName[0]['courseName'];
            return [val, 'student', designation, collegeName];
          } else {
            break;
          }
        default:
          return [];
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

Future<dynamic> getUserProfilePic() async {
  try {
    var query = "";
    query = "SELECT userType FROM UserLoginSession WHERE loginStatus=1;";
    var params = [];
    var users = await DBProvider.db.dynamicRead(query, params);

    if (users.isNotEmpty) {
      var user = users[0];
      var userType = user['userType'];
      //     6: "student",
      // 5: "parent",
      // 4: "ntStaff",
      // 3: "faculty",
      // 2: "head",
      // 1: "master"

      switch (userType) {
        case 2:
          query = "SELECT profilePic FROM Head WHERE "
              "userId = "
              "(SELECT userId FROM UserLoginSession WHERE loginStatus = 1);";
          var data = await DBProvider.db.dynamicRead(query, params);
          var profilePic = data[0]['profilePic'];
          return profilePic;
        case 3:
          query = "SELECT profilePic FROM Faculty WHERE "
              "userId = "
              "(SELECT userId FROM UserLoginSession WHERE loginStatus = 1);";
          var data = await DBProvider.db.dynamicRead(query, params);
          var profilePic = data[0]['profilePic'];
          return profilePic;
        case 6:
          query = "SELECT profilePic FROM Student WHERE "
              "userId = "
              "(SELECT userId FROM UserLoginSession WHERE loginStatus = 1);";
          var data = await DBProvider.db.dynamicRead(query, params);
          var profilePic = data[0]['profilePic'];
          return profilePic;
        default:
          return "";
      }
    } else {
      return "";
    }
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
      return "";
    }
  }
}
