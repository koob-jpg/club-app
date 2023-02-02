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

  final dbHelper = DatabaseHelper.instance;
  List<Student> students = [];
  List<Club> clubs = [];
  List<String> thisStudentsClubs = [];

  List<String> findclubs() {
    List<String> temp = [];
    for (int x = 0; x < students.length; x++) {
      if ((students[x].osis == widget.student.osis) &&
          (students[x].club != widget.student.club)) {
        thisStudentsClubs.add(students[x].club);
      }
    }
    return temp;
  }

  void _queryAllClubs() async {
    final allRows = await dbHelper.getClubs();
    clubs.clear();
    allRows.forEach((element) => clubs.add(Club.fromMap(element)));
    setState(() {});
  }

  void _queryAllStudents() async {
    final allRows = await dbHelper.getStudents();
    students.clear();
    allRows.forEach((element) => students.add(Student.fromMap(element)));
    setState(() {});
  }

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
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                      child: Text(
                        widget.student.osis,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                      child: Text(
                        widget.student.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                      child: Text(
                        widget.student.email,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                      child: Text(
                        widget.student.email,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                      child: Text(
                        widget.student.password,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange)),
                      child: TextButton(
                        child: const Text('Add Clubs?',
                            style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          _queryAllClubs();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              (students.isNotEmpty)
                  ? Center(
                      child: ListView.builder(
                          itemCount: thisStudentsClubs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              thisStudentsClubs[index],
                              style: const TextStyle(fontSize: 20),
                            );
                          }),
                    )
                  : TextButton(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange)),
                          child: const Text('REFRESH'),
                        ),
                      ),
                      onPressed: () {
                        _queryAllStudents();
                        setState(() {
                          thisStudentsClubs = findclubs();
                        });
                      },
                    ),
            ],
          ),
        ));
  }

  void _insertStudent(Student s) async {
    final id = await dbHelper.addStudent(s);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Club'),
      content: ListView.builder(
          itemCount: clubs.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onDoubleTap: () {
                _insertStudent(Student(
                    osis: widget.student.osis,
                    name: widget.student.name,
                    email: widget.student.email,
                    club: clubs[index].name,
                    password: widget.student.password));
                _queryAllStudents();
              },
              child: Center(
                child: Text(clubs[index].name),
              ),
            );
          }),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

// WidgetsFlutterBinding.ensureInitialized();
