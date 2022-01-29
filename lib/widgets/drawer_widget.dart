import 'package:TaskOS/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:TaskOS/constants/constants.dart';
import 'package:TaskOS/inner_screens/profile.dart';
import 'package:TaskOS/inner_screens/upload_task.dart';
import 'package:TaskOS/screens/all_workers.dart';
import 'package:TaskOS/screens/tasks_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  image: DecorationImage(
                      image: AssetImage('assets/images/task_schedule_00.png'),
                      alignment: Alignment.centerLeft)),
              child: Column(
                children: [
                  // Flexible(
                  //   flex: 1,
                  //   child: Image.network(
                  //       'https://cdn-icons-png.flaticon.com/512/4285/4285555.png',
                  //       width: 500,
                  //       height: 500,
                  //       fit: BoxFit.cover),
                  // ),
                  // SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(width: 120),
                      Text('Task OS',
                          style: TextStyle(
                            color: Constants.darkBlue,
                            fontSize: 40,
                            // fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  // Flexible(
                  //   child: Text(
                  //     'Task OS',
                  //     textAlign: TextAlign.end,
                  //     style: TextStyle(
                  //       color: Constants.darkBlue,
                  //       fontSize: 40,
                  //       // fontStyle: FontStyle.italic,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              )),
          SizedBox(height: 30),
          _listTiles(
              label: 'Task Home',
              fct: () => _navigateToAllTasksScreen(context),
              icon: Icons.task_outlined),
          _listTiles(
              label: 'Create Task',
              fct: () => _navigateToAddTaskScreen(context),
              icon: Icons.add_task),
          _listTiles(
              label: 'Worker Contacts',
              fct: () => _navigateToAllWorkersScreen(context),
              icon: Icons.workspaces_outlined),
          Divider(thickness: 1),
          _listTiles(
              label: 'My Profile',
              fct: () => _navigateToProfileScreen(context),
              icon: Icons.settings_outlined),
          // Divider(thickness: 1),
          _listTiles(
              label: 'Logout',
              fct: () {
                _logout(context);
              },
              icon: Icons.logout),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  void _navigateToProfileScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: _uid)),
    );
  }

  void _navigateToAllTasksScreen(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TasksScreen(),
        ),
      );

  void _navigateToAllWorkersScreen(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AllWorkersScreen(),
        ),
      );

  void _navigateToAddTaskScreen(context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadTask(),
        ),
      );

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/1252/1252006.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Sign out'),
                )
              ],
            ),
            content: Text(
              'Do you wann a sign out?',
              style: TextStyle(
                color: Constants.darkBlue,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.canPop(context) ? Navigator.pop(context) : null,
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserState(),
                        ));
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }

  Widget _listTiles(
          {required String label,
          required Function fct,
          required IconData icon}) =>
      ListTile(
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        onTap: () => fct(),
        leading: Icon(
          icon,
          color: Constants.darkBlue,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: Constants.darkBlue,
            fontSize: 20,
            // fontStyle: FontStyle.italic,
          ),
        ),
      );
}
