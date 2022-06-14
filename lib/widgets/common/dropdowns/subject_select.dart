import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../services/connection/faculty_mode_methods.dart';

class SubjectSelector extends StatefulWidget {
  final int courseId;
  final int yearId;
  final int semId;
  final Function(int, int, int, int) subjectSelection;

  const SubjectSelector({
    Key? key,
    required this.courseId,
    required this.yearId,
    required this.semId,
    required this.subjectSelection,
  }) : super(key: key);

  @override
  State<SubjectSelector> createState() => _SubjectSelectorState();
}

class _SubjectSelectorState extends State<SubjectSelector> {
  late final Future subjectFuture;
  // late int courseId;

  @override
  void initState() {
    // setState(() {
    //   courseId = widget.courseId;
    // });
    super.initState();
    subjectFuture = getSubjectsForCourseIdYearIdSemIdFrom(
      widget.courseId,
      widget.yearId,
      widget.semId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: subjectFuture,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.isNotEmpty) {
              var classes = snapshot.data;
              return SubjectSelection(
                courseId: widget.courseId,
                subjectSelection: widget.subjectSelection,
                yearId: widget.yearId,
                semId: widget.semId,
                subjectNames: classes,
              );
            } else {
              return const Text("No subjects for this course found");
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
class SubjectSelection extends StatefulWidget {
  final int courseId;
  final int yearId;
  final int semId;
  final Function(int, int, int, int) subjectSelection;
  final List subjectNames;
  const SubjectSelection({
    Key? key,
    required this.courseId,
    required this.subjectSelection,
    required this.subjectNames,
    required this.yearId,
    required this.semId,
  }) : super(key: key);

  @override
  State<SubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  late List subjectNames;
  late String selectedSubjectName;

  void handleSubjectSelection() async {
    if (kDebugMode) {
      log("selected subject name $selectedSubjectName");
    }

    var subjectDetails = await getSubjectDetails(
        selectedSubjectName, widget.yearId, widget.semId);
    if (kDebugMode) {
      log("subject details handle selection");
      log(subjectDetails.toString());
    }
    if (subjectDetails != null && subjectDetails.isNotEmpty) {
      widget.subjectSelection(subjectDetails['subjectId'], widget.courseId,
          widget.yearId, widget.semId);
    }
  }

  @override
  void initState() {
    if (widget.subjectNames.isNotEmpty) {
      setState(() {
        subjectNames = widget.subjectNames;
        selectedSubjectName = widget.subjectNames[0]['subjectName'];
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
          value: selectedSubjectName,
          dropdownColor: Colors.deepPurpleAccent.shade200,
          itemHeight: MediaQuery.of(context).size.height * 0.10,
          items: subjectNames.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              child: Text(
                e['subjectName'],
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              value: e['subjectName'],
            );
          }).toList(),
          onChanged: (selection) {
            setState(() {
              selectedSubjectName = selection.toString();
            });

            handleSubjectSelection();
          }),
    );
  }
}
