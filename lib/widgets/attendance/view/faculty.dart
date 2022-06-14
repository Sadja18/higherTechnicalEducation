// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../services/connection/faculty_mode_methods.dart';

class StudentAttendanceCalendarViewFacultyMode extends StatefulWidget {
  const StudentAttendanceCalendarViewFacultyMode({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceCalendarViewFacultyMode> createState() =>
      _StudentAttendanceCalendarViewFacultyModeState();
}

class _StudentAttendanceCalendarViewFacultyModeState
    extends State<StudentAttendanceCalendarViewFacultyMode> {
  late final Future getStudentAttendanceFuture;

  @override
  void initState() {
    super.initState();
    getStudentAttendanceFuture = readStudentAttendanceRecordsFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStudentAttendanceFuture,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (snapshot.hasError ||
                snapshot.hasData != true ||
                snapshot.data == null ||
                snapshot.data.isEmpty ||
                snapshot.data == false) {
              return SfCalendar();
            } else {
              var attendance = snapshot.data;
              return StudentAttendanceCalendarView(attendance: attendance);
            }
          }
        });
  }
}

class StudentAttendanceCalendarView extends StatefulWidget {
  final List attendance;
  const StudentAttendanceCalendarView({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  State<StudentAttendanceCalendarView> createState() =>
      _StudentAttendanceCalendarViewState();
}

class _StudentAttendanceCalendarViewState
    extends State<StudentAttendanceCalendarView> {
  late List attendances;
  final CalendarController _controller = CalendarController();

  List<Attendance> _getAttendance() {
    List<Attendance> records = [];

    for (var attendance in attendances) {
      DateTime startDateParsed = DateTime.parse(attendance['attendanceDate']);
      DateTime endDateParsed =
          DateTime.parse("${attendance['attendanceDate']} 23:59:59");

      String isSynced = attendance['isSynced'];
      var courseName = attendance['courseName'];
      var subjectName = attendance['subjectName'];
      var semName = attendance['semName'];
      var className =
          attendance['className'] != null && attendance['className'] != ""
              ? attendance['className']
              : "";
      var yearName = attendance['yearName'];
      var attendanceList = jsonDecode(attendance['absentStudentList']);
      var absentLength = attendanceList.length;

      var display =
          'Course: $courseName' + " \n" + "Subject: $subjectName" + "\n";
      if (className != "") {
        display = display + "Class: $className" + "\n";
      } else {
        display = display + "Year: $yearName " + " " + "Sem: $semName" + "\n";
      }
      display = display + "Absent Count: $absentLength";
      Color backColor = Colors.white;
      if (isSynced == 'yes') {
        backColor = Colors.green;
      } else {
        backColor = Colors.blue;
      }

      Attendance entry =
          Attendance(startDateParsed, endDateParsed, display, backColor, true);

      records.add(entry);
    }

    return records;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      attendances = widget.attendance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(),
      child: SfCalendar(
        allowDragAndDrop: false,
        allowAppointmentResize: false,
        controller: _controller,
        view: CalendarView.month,
        viewHeaderStyle: const ViewHeaderStyle(
          dateTextStyle: TextStyle(),
          dayTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        firstDayOfWeek: 1,
        showNavigationArrow: true,
        headerStyle: const CalendarHeaderStyle(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        monthViewSettings: const MonthViewSettings(
          dayFormat: 'EE',
          agendaItemHeight: 160.0,
          showTrailingAndLeadingDates: false,
          showAgenda: true,
          agendaStyle: AgendaStyle(
            dayTextStyle: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            dateTextStyle: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            appointmentTextStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // dayFormat: 'EE',
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22.0,
        ),
        dataSource: AttendanceDataSource(_getAttendance()),
      ),
    );
  }
}

class Attendance {
  DateTime startDate;
  DateTime endDate;
  String classes;
  Color appointmentColor;
  bool isAllDay = true;

  Attendance(
    this.startDate,
    this.endDate,
    this.classes,
    this.appointmentColor,
    this.isAllDay,
  );
}

class AttendanceDataSource extends CalendarDataSource {
  AttendanceDataSource(List<Attendance> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].startDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endDate;
  }

  @override
  Color getColor(int index) {
    return appointments![index].appointmentColor;
    // return colorVal;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String getSubject(int index) {
    return appointments![index].classes;
  }
}
