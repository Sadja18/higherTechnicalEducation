import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SubjectSelector extends StatefulWidget {
  final int courseId;
  final int yearId;
  final int semId;
  // get subject id, course id, year id, sem id
  final Function(int, int, int, int) subjectSelection;
  const SubjectSelector(
      {Key? key,
      required this.courseId,
      required this.yearId,
      required this.semId,
      required this.subjectSelection})
      : super(key: key);

  @override
  State<SubjectSelector> createState() => _SubjectSelectorState();
}

class _SubjectSelectorState extends State<SubjectSelector> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
