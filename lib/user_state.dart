import 'package:TaskOS/screens/auth/login.dart';
import 'package:TaskOS/screens/tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            print('User is not signed in yet');
            return Login();
          } else if (userSnapshot.hasData) {
            print('User is already signed in');
            return TasksScreen();
          } else if (userSnapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('An error has been occured!'),
              ),
            );
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        });
  }
}