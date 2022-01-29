import 'package:TaskOS/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:TaskOS/inner_screens/task_details.dart';
import 'package:TaskOS/screens/auth/login.dart';
import 'package:TaskOS/screens/tasks_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('An error has been occured!'),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter taskos',
              theme: ThemeData(
                scaffoldBackgroundColor: Color(0xFFEDE7DC),
                primarySwatch: Colors.blue,
              ),
              home: UserState());
        });
  }
}
