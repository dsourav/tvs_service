import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaondingPage extends StatefulWidget {
  @override
  _LaondingPageState createState() => _LaondingPageState();
}

class _LaondingPageState extends State<LaondingPage> {
  String name, surName, phone;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    getUser().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/adminHome');
      } else {
        SharedPreferences.getInstance().then((prefs) {
          name = prefs.getString('name');
          if (name != null) {
            Navigator.of(context).pushReplacementNamed('/userFormPage');
          } else {
            Navigator.of(context).pushReplacementNamed('/signUpUser');
          }
        });
      }
    });

    super.initState();
  }

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
