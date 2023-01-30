import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'main.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key, required this.title, required this.student});

  final String title;
  final Student student;

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Account Info'),
                Tab(
                  text: 'Club Info',
                )
              ],
            ),
            title: Text(widget.title),
          ),
          body: TabBarView(
            children: [],
          ),
        ));
  }
}

// WidgetsFlutterBinding.ensureInitialized();
