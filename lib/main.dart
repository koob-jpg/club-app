import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dbhelper.dart';

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

  @override
  void initState() {
    super.initState();
  }

  final dbHelper = DatabaseHelper.instance;
  List<Student> students = [
    Student(
        osis: '222',
        name: 'bob',
        email: 'koob',
        club: 'none',
        password: 'banana'),
  ];
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
                                setState(() {
                                  _queryAllStudents();
                                });
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
                                setState(() {});
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

  void _insertStudent(Student s) async {
    final id = await dbHelper.addStudent(s);
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