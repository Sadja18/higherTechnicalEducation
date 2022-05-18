import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/connection/faculty_mode_fetches.dart';

/// courseSelection returns three values:
/// courseId and noDept and duration
class CourseSelector extends StatefulWidget {
  final Function(int, String, String) courseSelection;
  const CourseSelector({Key? key, required this.courseSelection})
      : super(key: key);

  @override
  State<CourseSelector> createState() => _CourseSelectorState();
}

class _CourseSelectorState extends State<CourseSelector> {
  late final Future courseFuture;

  @override
  void initState() {
    super.initState();
    courseFuture = getCoursesFromServerFacultyMode();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: courseFuture,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              child: Text(
                  "There was a problem fetching required data from server."),
            ),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data.isNotEmpty) {
          var courses = snapshot.data;
          if (kDebugMode) {
            print("object courses");
            print(courses.toString());
          }
          return CourseDropdown(
            courses: courses,
            courseSelection: widget.courseSelection,
          );
        } else {
          return const SizedBox(
            height: 0,
          );
        }
      },
    );
  }
}

/// courseSelection returns three values:
/// courseId and noDept and course duration
class CourseDropdown extends StatefulWidget {
  final List courses;
  final Function(int, String, String) courseSelection;
  const CourseDropdown(
      {Key? key, required this.courses, required this.courseSelection})
      : super(key: key);

  @override
  State<CourseDropdown> createState() => _CourseDropdownState();
}

class _CourseDropdownState extends State<CourseDropdown> {
  late List courses;
  late String selectedCourseCode;

  void handleSelection() async {
    var res = await getCourseDetails("Faculty", selectedCourseCode);
    if (kDebugMode) {
      log(res.toString());
    }

    if (res.isNotEmpty) {
      widget.courseSelection(res[0], res[1], res[2].toString());
    }
  }

  @override
  void initState() {
    setState(() {
      courses = widget.courses;
      selectedCourseCode = widget.courses[0]['courseCode'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: MediaQuery.of(context).size.height * 0.05,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(
        top: 6.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.purpleAccent,
      ),
      child: DropdownButton(
          value: selectedCourseCode,
          dropdownColor: Colors.deepPurpleAccent.shade200,
          items: courses.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              child: Text(
                e['courseCode'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              value: e['courseCode'],
            );
          }).toList(),
          onChanged: (selection) {
            setState(() {
              selectedCourseCode = selection.toString();
            });
            if (kDebugMode) {
              print("Selected course");
              print(selection.toString());
            }

            handleSelection();
          }),
    );
  }
}
