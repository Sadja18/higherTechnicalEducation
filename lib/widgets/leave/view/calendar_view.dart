import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LeaveCalendarViewWidget extends StatefulWidget {
  final List leavesData;
  const LeaveCalendarViewWidget({Key? key, required this.leavesData})
      : super(key: key);

  @override
  State<LeaveCalendarViewWidget> createState() =>
      _LeaveCalendarViewWidgetState();
}

class _LeaveCalendarViewWidgetState extends State<LeaveCalendarViewWidget> {
  late List leavesData;
  final CalendarController _controller = CalendarController();

  List<Leaves> _getLeaves() {
    List<Leaves> leaves = [];
    return leaves;
  }

  @override
  void initState() {
    setState(() {
      leavesData = widget.leavesData;
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
        dataSource: LeaveDataSource(_getLeaves()),
      ),
    );
  }
}

class Leaves {
  DateTime startDate;
  DateTime endDate;
  String reason;
  Color backColors;
  // String className="";
  // bool synced;
  bool isAllDay = true;
  Leaves(
    this.startDate,
    this.endDate,
    this.reason,
    this.backColors,
    this.isAllDay,
  );
}

class LeaveDataSource extends CalendarDataSource {
  LeaveDataSource(List<Leaves> source) {
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
    return appointments![index].backColors;
    // return colorVal;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String getSubject(int index) {
    return appointments![index].reason;
  }
}
