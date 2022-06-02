import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:higher/services/database/handler.dart';

import '../../../services/connection/base.dart';

class DropdownDeptSelector extends StatefulWidget {
  final Function(int) deptSelector;
  const DropdownDeptSelector({Key? key, required this.deptSelector})
      : super(key: key);

  @override
  State<DropdownDeptSelector> createState() => _DropdownDeptSelectorState();
}

class _DropdownDeptSelectorState extends State<DropdownDeptSelector> {
  late var selectedDept = {};
  late final Future? myFuture;
  @override
  void initState() {
    super.initState();
    myFuture = getDepartmentDataFromServerMasterMode();
  }

  void deptSelectionHandler(String deptName) async {
    if (kDebugMode) {
      log("Selected dept");
      log(deptName);
      // log(deptId.toString());
    }

    if (deptName != "") {
      var res = await getDeptIdFromDeptName("Master", deptName);
      if (kDebugMode) {
        log('selected deptId Dropdown main widget');
        log(res.toString());
      }
      widget.deptSelector(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.purpleAccent),
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      child: FutureBuilder(
          future: myFuture,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.isNotEmpty) {
              var departmentData = snapshot.data;
              return dropDownSubWidget(
                deptList: departmentData,
                deptSelectionHandler: deptSelectionHandler,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return const Text("");
          }),
    );
  }
}

class dropDownSubWidget extends StatefulWidget {
  final List deptList;
  final Function(String deptName) deptSelectionHandler;
  const dropDownSubWidget(
      {Key? key, required this.deptList, required this.deptSelectionHandler})
      : super(key: key);

  @override
  State<dropDownSubWidget> createState() => _dropDownSubWidgetState();
}

class _dropDownSubWidgetState extends State<dropDownSubWidget> {
  late String selectedDeptName;

  @override
  void initState() {
    setState(() {
      selectedDeptName = widget.deptList[0]['deptName'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        dropdownColor: Colors.deepPurple,
        value: selectedDeptName,
        items: widget.deptList.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  e['deptName'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            value: e['deptName'].toString(),
          );
        }).toList(),
        onChanged: (selection) {
          if (kDebugMode) {
            log(selection.toString());
            log(selection.runtimeType.toString());
          }
          setState(() {
            selectedDeptName = selection.toString();
          });
          widget.deptSelectionHandler(selectedDeptName);
        },
      ),
    );
  }
}
