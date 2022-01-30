import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskos/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text(
                    'An error has been occured!',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.red.shade800),
                  ),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter taskos',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFEDE7DC),
              primarySwatch: Colors.blue,
            ),
            home: UserState());
      },
    );
  }
}
