import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../services/connection/faculty_mode_fetches.dart';

class ClassSelector extends StatefulWidget {
  final int courseId;
  final Function(int, int, int) classSelection;
  const ClassSelector(
      {Key? key, required this.courseId, required this.classSelection})
      : super(key: key);

  @override
  State<ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<ClassSelector> {
  late final Future classFuture;
  late int courseId;

  @override
  void initState() {
    setState(() {
      courseId = widget.courseId;
    });
    super.initState();
    classFuture = getClassesForCourseId(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getClassesForCourseId(courseId),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.isNotEmpty) {
              var classes = snapshot.data;
              return ClassSelection(
                  courseId: courseId,
                  classSelection: widget.classSelection,
                  classNames: classes);
            } else {
              return const Text("No classes for this course found");
            }
          }
        }
        return const SizedBox(
          height: 0,
        );
      },
    );
  }
}

/// class selection returns three values:
/// classId , yearId and semId
class ClassSelection extends StatefulWidget {
  final int courseId;
  final List classNames;
  final Function(int, int, int) classSelection;
  const ClassSelection(
      {Key? key,
      required this.courseId,
      required this.classSelection,
      required this.classNames})
      : super(key: key);

  @override
  State<ClassSelection> createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {
  late List classNames;
  late String selectedClassName;

  void handleClassSelection() async {
    if (kDebugMode) {
      print("selected class name $selectedClassName");
    }

    var classDetails =
        await getClassDetails(widget.courseId, selectedClassName);
    if (classDetails.isNotEmpty) {
      if (kDebugMode) {
        log('selected classDetail');
        log(classDetails.toString());
      }
      widget.classSelection(classDetails['classId'], classDetails['yearId'],
          classDetails['semId']);
    }
  }

  @override
  void initState() {
    if (widget.classNames.isNotEmpty) {
      setState(() {
        classNames = widget.classNames;
        selectedClassName = widget.classNames[0]['className'];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      margin: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.purpleAccent,
      ),
      child: DropdownButton(
          isExpanded: true,
          underline: const DropdownButtonHideUnderline(
            child: SizedBox(
              height: 0,
            ),
          ),
          value: selectedClassName,
          dropdownColor: Colors.deepPurpleAccent.shade200,
          itemHeight: MediaQuery.of(context).size.height * 0.10,
          items: classNames.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              child: Text(
                e['className'],
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              value: e['className'],
            );
          }).toList(),
          onChanged: (selection) {
            setState(() {
              selectedClassName = selection.toString();
            });
            if (kDebugMode) {
              print("Selected class");
              print(selection.toString());
            }
            handleClassSelection();
          }),
    );
  }
}
