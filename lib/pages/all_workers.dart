import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskos/widgets/all_workers_widget.dart';
import 'package:taskos/widgets/drawer_widget.dart';

// Fields should be 'final' or be Stateful widget with parameter 'context' removed from '_taskCategoryDialog' function.
class AllWorkersPage extends StatelessWidget {
  const AllWorkersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('All workers', style: TextStyle(color: Colors.pink)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AllWorkersWidget(
                      userId: snapshot.data!.docs[index]['userId'],
                      userName: snapshot.data!.docs[index]['userFullName'],
                      userEmail: snapshot.data!.docs[index]['userEmail'],
                      userPhoneNumber: snapshot.data!.docs[index]
                          ['userPhoneNumber'],
                      userJobTitle: snapshot.data!.docs[index]['userJobTitle'],
                      userImageUrl: snapshot.data!.docs[index]['userImageUrl'],
                    );
                  });
            } else {
              return const Center(
                child: Text('There is no users'),
              );
            }
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        },
      ),
    );
  }
}
