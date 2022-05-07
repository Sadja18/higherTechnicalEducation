import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class FacultyOwnAttendanceCalendarView extends StatefulWidget {
  final List attendanceData;
  const FacultyOwnAttendanceCalendarView(
      {Key? key, required this.attendanceData})
      : super(key: key);

  @override
  State<FacultyOwnAttendanceCalendarView> createState() =>
      _FacultyOwnAttendanceCalendarViewState();
}

class _FacultyOwnAttendanceCalendarViewState
    extends State<FacultyOwnAttendanceCalendarView> {
  final CalendarController _controller = CalendarController();

  late List attendances;
  List<Attendance> _getAttendances() {
    List<Attendance> tmp = [];
    return tmp;
  }

  @override
  void initState() {
    setState(() {
      setState(() {
        attendances = widget.attendanceData;
      });
    });
    super.initState();
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
          agendaItemHeight: 40.0,
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
        // dataSource:,
      ),
    );
  }
}

class Attendance {}
