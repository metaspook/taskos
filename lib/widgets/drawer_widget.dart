import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskos/pages/all_tasks.dart';
import 'package:taskos/pages/all_workers.dart';
import 'package:taskos/pages/inner/profile.dart';
import 'package:taskos/pages/inner/task_upload.dart';
import 'package:taskos/user_state.dart';
import 'package:taskos/utils/constants.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                  color: Colors.cyan,
                  image: DecorationImage(
                      image: AssetImage('assets/images/task_schedule_00.png'),
                      alignment: Alignment.centerLeft)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      SizedBox(width: 120),
                      Text(
                        'Task OS',
                        style: TextStyle(
                          color: Constants.darkBlue,
                          fontSize: 40,
                          // fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          const SizedBox(height: 30),
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
          const Divider(thickness: 1),
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
          const Divider(thickness: 1),
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
      MaterialPageRoute(builder: (context) => ProfilePage(userId: _uid)),
    );
  }

  void _navigateToAllTasksScreen(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AllTasksPage(),
        ),
      );

  void _navigateToAllWorkersScreen(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AllWorkersPage(),
        ),
      );

  void _navigateToAddTaskScreen(context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskUpload(),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sign out'),
                )
              ],
            ),
            content: const Text(
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
                  child: const Text('Cancel')),
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
                  child: const Text('OK', style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }

  Widget _listTiles(
          {required String label,
          required Function fct,
          required IconData icon}) =>
      ListTile(
        onTap: () => fct(),
        leading: Icon(
          icon,
          color: Constants.darkBlue,
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Constants.darkBlue,
            fontSize: 20,
          ),
        ),
      );
}
