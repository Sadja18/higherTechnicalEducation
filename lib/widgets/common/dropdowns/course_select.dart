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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: MediaQuery.of(context).size.height * 0.05,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.purpleAccent,
      ),
      child: FutureBuilder(
        future: getCoursesFromServerFacultyMode(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isNotEmpty) {
            var courses = snapshot.data;
            return CourseDropdown(
              courses: courses,
              courseSelection: widget.courseSelection,
            );
          }
          return const SizedBox(
            height: 0,
          );
        },
      ),
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
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(),
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
