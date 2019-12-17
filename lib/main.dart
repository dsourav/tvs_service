import 'package:flutter/material.dart';
import 'package:tvs_service/admin/adminHOme.dart';
import 'package:tvs_service/admin/adminLogin.dart';
import 'package:tvs_service/advertiseDialouge.dart';
import 'package:tvs_service/landingPage.dart';
import 'package:tvs_service/signUpUser.dart';
import 'package:tvs_service/userFormPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TVS Appoinment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LaondingPage(),
        home: CustomDialog(),
      routes: {
        '/landingPage':(BuildContext context)=>LaondingPage(),
        '/userFormPage':(BuildContext context)=>UserFormPAge(),
        '/signUpUser':(BuildContext context)=>SignUpUser(),
        '/adminLogin':(BuildContext context)=>AdminLogin(),
         '/adminHome':(BuildContext context)=>AdminHome(),
      },
    );
  }
}

