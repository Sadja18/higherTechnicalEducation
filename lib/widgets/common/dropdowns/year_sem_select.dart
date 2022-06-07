import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/connection/faculty_mode_methods.dart';

class YearDropdown extends StatefulWidget {
  final Function(int) yearSelection;
  const YearDropdown({Key? key, required this.yearSelection}) : super(key: key);

  @override
  State<YearDropdown> createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getYearsFromServerFacultyMode(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError ||
                snapshot.hasData != true ||
                snapshot.data == null ||
                snapshot.data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(
                  6.0,
                ),
                child: SizedBox(
                  child: Text("No course years found"),
                ),
              );
            } else {
              var years = snapshot.data;
              return YearSelector(
                  years: years, yearSelection: widget.yearSelection);
            }
          }
        });
  }
}

class YearSelector extends StatefulWidget {
  final List years;
  final Function(int) yearSelection;
  const YearSelector(
      {Key? key, required this.years, required this.yearSelection})
      : super(key: key);

  @override
  State<YearSelector> createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  late String selectedYearName;
  late List<String> yearNames;

  void handleSelection() async {
    var year = await getYearDetails(selectedYearName);

    if (year.isNotEmpty) {
      widget.yearSelection(year[0]['yearId']);
    }
  }

  @override
  void initState() {
    setState(() {
      selectedYearName = widget.years[0]['yearName'];
    });
    List<String> tmp = [];

    for (var year in widget.years) {
      var name = year['yearName'];
      tmp.add(name);
    }
    setState(() {
      yearNames = tmp;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(
        vertical: 6.0,
      ),
      decoration: const BoxDecoration(color: Colors.purpleAccent),
      child: DropdownButton(
          isExpanded: true,
          underline: const DropdownButtonHideUnderline(
            child: SizedBox(
              height: 0,
            ),
          ),
          value: selectedYearName,
          dropdownColor: Colors.deepPurpleAccent.shade200,
          itemHeight: MediaQuery.of(context).size.height * 0.10,
          items: yearNames.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              value: e,
            );
          }).toList(),
          onChanged: (selection) {
            setState(() {
              selectedYearName = selection.toString();
            });
            if (kDebugMode) {
              print("Selected year");
              print(selection.toString());
            }

            handleSelection();
          }),
    );
  }
}

class SemDrodown extends StatefulWidget {
  final int yearId;
  final Function(int) semSelection;
  const SemDrodown({Key? key, required this.yearId, required this.semSelection})
      : super(key: key);

  @override
  State<SemDrodown> createState() => _SemDrodownState();
}

class _SemDrodownState extends State<SemDrodown> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSemestersFromServerFacultyMode(widget.yearId),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 6.0,
            ),
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError ||
              snapshot.hasData != true ||
              snapshot.data == null ||
              snapshot.data.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(
                6.0,
              ),
              child: SizedBox(
                child: Text("No semesters found"),
              ),
            );
          } else {
            var semesters = snapshot.data;
            if (kDebugMode) {
              log(semesters.toString());
            }
            // return Text(semesters.toString());
            return SemesterSelector(
              semesters: semesters,
              semSelection: widget.semSelection,
            );
          }
        }
      },
    );
  }
}

class SemesterSelector extends StatefulWidget {
  final List semesters;
  final Function(int) semSelection;
  const SemesterSelector({
    Key? key,
    required this.semesters,
    required this.semSelection,
  }) : super(key: key);

  @override
  State<SemesterSelector> createState() => _SemesterSelectorState();
}

class _SemesterSelectorState extends State<SemesterSelector> {
  late String selectedSemesterName;
  late List semesters;
  void handleSelection() async {
    var res = await getSemDetails(selectedSemesterName);

    if (res.isNotEmpty) {
      widget.semSelection(res[0]['semId']);
    }
  }

  @override
  void initState() {
    var tmp = [];
    // for (var sem in widget.semesters) {
    //   tmp.add(sem['semName']);
    // }
    setState(() {
      // semesters = tmp;
      selectedSemesterName = widget.semesters[0]['semName'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
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
          value: selectedSemesterName,
          dropdownColor: Colors.deepPurpleAccent.shade200,
          itemHeight: MediaQuery.of(context).size.height * 0.10,
          items: widget.semesters.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              child: Text(
                e['semName'],
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              value: e['semName'],
            );
          }).toList(),
          onChanged: (selection) {
            setState(() {
              selectedSemesterName = selection.toString();
            });
            if (kDebugMode) {
              print("Selected sem");
              print(selection.toString());
            }

            handleSelection();
          }),
    );
  }
}
