import 'package:club_app_v2/dbhelper.dart';
import 'package:flutter/material.dart';
import 'dbhelper.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key, required this.title, required this.staff});

  final String title;
  final Club staff;

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${widget.title}'),
      ),
      body: ListView(
        children: [
          Text(
            widget.staff.name,
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Meeting Date: ${widget.staff.meeting}',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Room: ${widget.staff.room}',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Club Advisor: ${widget.staff.advisor}',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Advisor email: ${widget.staff.aemail}',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'President OSIS: ${widget.staff.pres}',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Vice President OSIS: ${widget.staff.vp}',
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
