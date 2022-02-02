import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskos/pages/inner/task_details.dart';
import 'package:taskos/services/methods.dart';
import 'package:taskos/utils/constants.dart';

class TaskWidget extends StatefulWidget {
  final String taskId;
  final String taskTitle;
  final String taskDescription;
  final String authorId;
  final bool isDone;

  const TaskWidget({
    Key? key,
    required this.taskId,
    required this.taskTitle,
    required this.taskDescription,
    required this.authorId,
    required this.isDone,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () async {
          final DocumentSnapshot? commenterDoc = await FirebaseFirestore
              .instance
              .collection('users')
              .doc(_userId)
              .get();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(
                userId: _userId,
                userFullName: commenterDoc!.get('userFullName'),
                userImageUrl: commenterDoc.get('userImageUrl'),
                taskId: widget.taskId,
                authorId: widget.authorId,
              ),
            ),
          );
        },
        onLongPress: _deleteDialog,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.asset(widget.isDone
                ? 'assets/images/done_00.png'
                : 'assets/images/clock_00.png'),
          ),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Constants.darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale_outlined,
              color: Colors.pink.shade800,
            ),
            Text(
              widget.taskDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink.shade800,
        ),
      ),
    );
  }

  _deleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (widget.authorId == _userId) {
                    await FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(widget.taskId)
                        .delete();
                    await Fluttertoast.showToast(
                        msg: "The task has been deleted",
                        toastLength: Toast.LENGTH_SHORT,
                        // gravity: ToastGravity.CENTER,
                        // timeInSecForIosWeb: 1,
                        // backgroundColor: Colors.red,
                        // textColor: Colors.white,
                        fontSize: 18.0);
                    if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                  } else {
                    if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                    Methods.showErrorDialog(
                        ctx: ctx, error: "You can't perform this action");
                  }
                } catch (error) {
                  if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                  Methods.showErrorDialog(
                      ctx: ctx, error: "This task can't be deleted");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
