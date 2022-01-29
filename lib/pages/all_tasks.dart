import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskos/utils/constants.dart';
import 'package:taskos/widgets/drawer_widget.dart';
import 'package:taskos/widgets/task_widget.dart';

// Fields should be 'final' or be Stateful widget with parameter 'context' removed from '_taskCategoryDialog' function.
class AllTasksPage extends StatefulWidget {
  @override
  _AllTasksPageState createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  String? taskCategoryFilter;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          // leading: Builder(
          //   builder: (ctx) {
          //     return IconButton(
          //       icon: Icon(
          //         Icons.menu,
          //         color: Colors.black,
          //       ),
          //       onPressed: () {
          //         Scaffold.of(ctx).openDrawer();
          //       },
          //     );
          //   },
          // ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Tasks',
            style: TextStyle(color: Colors.pink),
          ),
          actions: [
            IconButton(
                onPressed: () => _taskCategoryDialog(size: size),
                icon: Icon(Icons.filter_list_outlined, color: Colors.black))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          //there was a null error just add those lines
          stream: taskCategoryFilter == null
              ? FirebaseFirestore.instance
                  .collection('tasks')
                  .orderBy('creationDateTimeStamp', descending: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('tasks')
                  .where('taskCategory', isEqualTo: taskCategoryFilter)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TaskWidget(
                        taskTitle: snapshot.data!.docs[index]['taskTitle'],
                        taskDescription: snapshot.data!.docs[index]
                            ['taskDescription'],
                        taskId: snapshot.data!.docs[index]['taskId'],
                        authorId: snapshot.data!.docs[index]['authorId'],
                        isDone: snapshot.data!.docs[index]['isDone'],
                      );
                    });
              } else {
                return Center(
                  child: Text('There is no tasks'),
                );
              }
            }
            return Center(
                child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ));
          },
        ));
  }

  _taskCategoryDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Task Category',
              style: TextStyle(fontSize: 20, color: Colors.pink.shade800),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.taskCategoryList.length,
                  itemBuilder: (ctxx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() => taskCategoryFilter =
                            Constants.taskCategoryList[index]);
                        Constants.navPop(ctx);
                        // print('taskCategoryList[index], ${Constants.taskCategoryList[index]}');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red.shade200,
                          ),
                          // SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.taskCategoryList[index],
                              style: TextStyle(
                                  color: Constants.darkBlue,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () => Constants.navPop(ctx),
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => taskCategoryFilter = null);
                  Constants.navPop(ctx);
                },
                child: Text('Cancel filter'),
              ),
            ],
          );
        });
  }
}
