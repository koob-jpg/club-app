import 'package:club_app_v2/studentScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dbhelper.dart';
import 'staffScreen.dart';
import 'staffScreen.dart';

void main() async {
  runApp(const ClubApp());
}

class ClubApp extends StatelessWidget {
  const ClubApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': ((context) => const LoginScreen(title: 'Club App Login Page')),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _studentOSISController = TextEditingController();
  final TextEditingController _studentPasswordController =
      TextEditingController();
  final TextEditingController _staffOSISController = TextEditingController();
  final TextEditingController _staffPasswordController =
      TextEditingController();

  Student exampleStudent = Student(
      osis: '220',
      name: 'Joe',
      email: 'koob',
      club: 'Astrology',
      password: 'banana');

  Club exampleClub = Club(
      name: 'Astrology',
      meeting: 'Thursday',
      room: '301',
      advisor: 'Ms. Qiu',
      aemail: 'qiubx',
      pres: '220',
      vp: '111');

  @override
  void initState() {
    super.initState();
  }

  void _insertStudent(Student s) async {
    final id = await dbHelper.addStudent(s);
  }

  void _insertClub(Club c) async {
    final id = await dbHelper.addClub(c);
  }

  final dbHelper = DatabaseHelper.instance;
  List<Student> students = [];
  List<Club> clubs = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Student',
                ),
                Tab(
                  text: 'Staff',
                )
              ],
            ),
            title: Text(widget.title),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        Container(
                          height: 50,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            'Student LogIN Page',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 60,
                            ),
                          ),
                        ),
                        Container(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _studentOSISController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter OSIS'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _studentPasswordController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password'),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              child: const Text('Login'),
                              onPressed: () {
                                _queryAllStudents();
                                if (matchStudentAccount(
                                    _studentOSISController.text,
                                    _studentPasswordController.text)) {
                                  Student s =
                                      findStudent(_studentOSISController.text);
                                  _studentOSISController.clear();
                                  _studentPasswordController.clear();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentScreen(
                                            title:
                                                'Hello, ${s.name.toString()}',
                                            student: s),
                                      ));
                                } else {
                                  _studentOSISController.clear();
                                  _studentPasswordController.clear();
                                  Navigator.pop(context);
                                }
                              }),
                        ),
                        Container(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            child: const Text(
                              'Create Account?',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context));
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: (() {
                              setState(() {
                                _insertClub(exampleClub);
                                _insertStudent(exampleStudent);
                              });
                            }),
                            child: const Text(
                                'Click this to use example club and student'))
                      ],
                    )),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        Container(
                          height: 50,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            'Staff LogIN Page',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 60,
                            ),
                          ),
                        ),
                        Container(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _staffOSISController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter OSIS'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _staffPasswordController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password'),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              child: const Text('Login'),
                              onPressed: () {
                                if (checkStaff(_staffOSISController.text,
                                    _staffPasswordController.text)) {
                                  Student f =
                                      findStudent(_staffOSISController.text);
                                  Club g = findClub(_staffOSISController.text);
                                  _staffOSISController.clear();
                                  _staffPasswordController.clear();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => StaffScreen(
                                              title: f.name, staff: g))));
                                } else {
                                  _staffOSISController.clear();
                                  _staffPasswordController.clear();
                                  Navigator.pop(context);
                                }
                              }),
                        ),
                        Container(
                          height: 15,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  void _queryAllStudents() async {
    final allRows = await dbHelper.getStudents();
    students.clear();
    allRows.forEach((element) => students.add(Student.fromMap(element)));
    setState(() {});
  }

  void _queryAllClubs() async {
    final allRows = await dbHelper.getClubs();
    clubs.clear();
    allRows.forEach((element) => clubs.add(Club.fromMap(element)));
    setState(() {});
  }

  void _updateStudent() async {}

  void _deleteStudent(String osis, String club) async {
    final rowsdeleted = await dbHelper.removeStudent(osis, club);
  }

  bool matchStudentAccount(String osis, String password) {
    for (int x = 0; x < students.length; x++) {
      if ((students[x].osis == osis) && (students[x].password == password)) {
        return true;
      }
    }
    return false;
  }

  Student findStudent(String osis) {
    _queryAllStudents();
    for (int x = 0; x < students.length; x++) {
      if (students[x].osis == osis) {
        return students[x];
      }
    }
    return Student(
        osis: '0000',
        name: '0000',
        email: '0000',
        club: '0000',
        password: '0000');
  }

  Club findClub(String osis) {
    _queryAllClubs();
    for (int x = 0; x < clubs.length; x++) {
      if (clubs[x].pres == osis || clubs[x].vp == osis) {
        return clubs[x];
      }
    }
    return Club(
        name: '0000',
        meeting: '0000',
        room: '0000',
        advisor: '0000',
        aemail: '0000',
        pres: '0000',
        vp: '0000');
  }

  bool checkStaff(String osis, String password) {
    _queryAllClubs();
    _queryAllStudents();
    for (int x = 0; x < clubs.length; x++) {
      if (osis == clubs[x].vp || osis == clubs[x].pres) {
        for (int y = 0; y < students.length; y++) {
          if (password == students[y].password && osis == students[y].osis) {
            return true;
          }
        }
      }
    }
    return false;
  }

  final TextEditingController _osisController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Account Information'),
      content: Column(
        children: [
          TextField(
            controller: _osisController,
            decoration: const InputDecoration(hintText: 'Enter OSIS'),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Enter Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'Enter Password'),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CREATE'),
          onPressed: () {
            Navigator.of(context).pop();
            _insertStudent(Student(
                osis: _osisController.text,
                name: _nameController.text,
                email: _emailController.text,
                club: 'none',
                password: _passwordController.text));
            _osisController.clear();
            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
          },
        ),
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
            _osisController.clear();
            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
          },
        )
      ],
    );
  }
}




//ALL QUERIES WIL RETURN A LIST<MAP<STRING, OBJECT>> SO CONVERT THAT LIST INTO USABLE DATA