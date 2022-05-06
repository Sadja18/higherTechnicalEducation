import 'package:flutter/material.dart';

class MasterLeaveApproveTableWidget extends StatefulWidget {
  final List leaveRequests;
  const MasterLeaveApproveTableWidget({Key? key, required this.leaveRequests})
      : super(key: key);

  @override
  State<MasterLeaveApproveTableWidget> createState() =>
      _MasterLeaveApproveTableWidgetState();
}

class _MasterLeaveApproveTableWidgetState
    extends State<MasterLeaveApproveTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      alignment: Alignment.topCenter,
      child: Text(
        widget.leaveRequests.toString(),
      ),
    );
  }
}
