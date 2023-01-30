import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'main.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'club.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  var s = 'students';
  var c = 'clubs';

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students(
        osis TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        club TEXT,
        password TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE clubs(
        name TEXT PRIMARY KEY,
        meeting TEXT,
        room TEXT,
        advisor TEXT,
        aemail TEXT,
        pres TEXT,
        vp TEXT
      )
      ''');
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    Database db = await instance.database;
    return await db.query(
      s,
      orderBy: 'osis',
    );
  }

  Future<List<Map<String, dynamic>>> getClubs() async {
    Database db = await instance.database;
    return await db.query(
      c,
      orderBy: 'name',
    );
  }

  Future<int> addStudent(Student student) async {
    Database db = await instance.database;
    return await db.insert(s, student.toMap());
  }

  Future<int> addClub(Club club) async {
    Database db = await instance.database;
    return await db.insert(c, club.toMap());
  }

  Future<int> removeStudent(String osis, String club) async {
    Database db = await instance.database;
    return await db
        .rawDelete('DELETE FROM $s WHERE osis = $osis AND club = $club');
  }

  Future<int> removeClub(String name) async {
    Database db = await instance.database;
    return await db.delete(c, where: 'name = ?', whereArgs: [name]);
  }

  Future<int> updateStudent(Student student) async {
    Database db = await instance.database;
    return await db.update(s, student.toMap(),
        where: 'osis = ?', whereArgs: [student.osis]);
  }

  Future<int> updateClub(Club club) async {
    Database db = await instance.database;
    return await db
        .update(c, club.toMap(), where: 'name = ?', whereArgs: [club.name]);
  }
}

class Student {
  final String osis;
  final String name;
  final String email;
  final String club;
  final String password;

  const Student(
      {required this.osis,
      required this.name,
      required this.email,
      required this.club,
      required this.password});

  Map<String, dynamic> toMap() {
    return {'osis': osis, 'name': name, 'email': email, 'club': club};
  }

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
      osis: json['osis'],
      name: json['name'],
      email: json['email'],
      club: json['club'],
      password: json['password']);

  @override
  String toString() {
    return 'Student{osis: $osis, name: $name, email: $email, club: $club}';
  }
}

class Club {
  final String name;
  final String meeting;
  final String room;
  final String advisor;
  final String aemail;
  final String pres;
  final String vp;

  const Club(
      {required this.name,
      required this.meeting,
      required this.room,
      required this.advisor,
      required this.aemail,
      required this.pres,
      required this.vp});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'meeting': meeting,
      'room': room,
      'advisor': advisor,
      'aemail': aemail,
      'pres': pres,
      'vp': vp
    };
  }

  factory Club.fromMap(Map<String, dynamic> json) => new Club(
      name: json['name'],
      meeting: json['meeting'],
      room: json['room'],
      advisor: json['advisor'],
      aemail: json['aemail'],
      pres: json['pres'],
      vp: json['vp']);

  @override
  String toString() {
    return 'Club{name: $name, meeting: $meeting, room: $room, advisor: $advisor, aemail: $aemail, pres: $pres, vp: $vp}';
  }
}
