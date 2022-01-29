import 'dart:ui';
import 'package:TaskOS/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:TaskOS/constants/constants.dart';
import 'package:TaskOS/widgets/comment_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({
    required this.userId,
    required this.userFullName,
    required this.userImageUrl,
    required this.taskId,
    required this.authorId,
  });
  final String userId;
  final String userFullName;
  final String userImageUrl;
  final String taskId;
  final String authorId;

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  var _textStyle = TextStyle(
      color: Constants.darkBlue, fontSize: 13, fontWeight: FontWeight.normal);
  var _titleStyle = TextStyle(
      color: Constants.darkBlue, fontWeight: FontWeight.bold, fontSize: 20);
  TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  bool isDeadlineAvailable = false;
  bool? _isDone;
  String? authorName;
  String? authorJobTitle;
  String? authorImageUrl;
  // String? _userFullName;
  // String? _userImageUrl;
  String? taskTitle;
  String? taskCategory;
  String? taskDescription;
  String? postedDate;
  String? deadlineDate;
  Timestamp? creationDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? user = FirebaseAuth.instance.currentUser;
  //                                             final _uid = user!.uid

  @override
  void initState() {
    super.initState();
    getTaskData();
  }

  Future<void> getTaskData() async {
    // User? user = _auth.currentUser;
    // final _uid = user!.uid;
    // final DocumentSnapshot getCommenterInfoDoc =
    //     await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    // if (getCommenterInfoDoc == null) {
    //   return;
    // } else {
    //   setState(() {
    //     _loggedUserName = getCommenterInfoDoc.get('name');
    //     _loggedInUserImageUrl = getCommenterInfoDoc.get('userImage');
    //   });
    // }

    final DocumentSnapshot? userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.authorId)
        .get();
    if (userDoc != null)
      setState(() {
        authorName = userDoc.get('userFullName');
        authorJobTitle = userDoc.get('userJobTitle');
        authorImageUrl = userDoc.get('userImageUrl');
      });
    final DocumentSnapshot? taskDoc = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    if (taskDoc != null)
      setState(() {
        taskTitle = taskDoc.get('taskTitle');
        taskDescription = taskDoc.get('taskDescription');
        _isDone = taskDoc.get('isDone');
        creationDateTimeStamp = taskDoc.get('creationDateTimeStamp');
        deadlineDateTimeStamp = taskDoc.get('deadlineDateTimeStamp');
        deadlineDate = taskDoc.get('deadlineDate');
        var postDate = creationDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });
    var date = deadlineDateTimeStamp!.toDate();
    isDeadlineAvailable = date.isAfter(DateTime.now());
  }

  Future<void> _isDoneState(bool state) async {
    widget.authorId == widget.userId
        ? await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .update({'isDone': state})
            .then((value) => setState(() => _isDone = state))
            .catchError((error) => GlobalMethod.showErrorDialog(
                ctx: context, error: "Action can't be performed"))
        : GlobalMethod.showErrorDialog(
            ctx: context, error: "You can't perform this action");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(taskTitle == null ? 'N/A' : taskTitle!,
            style: TextStyle(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        // title: TextButton(
        //   onPressed: () => Navigator.pop(context),
        //   child: Text('Back',
        //       style: TextStyle(
        //           color: Constants.darkBlue,
        //           fontStyle: FontStyle.italic,
        //           fontSize: 20)),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 15),
            // Text(taskTitle == null ? '' : taskTitle!,
            //     style: TextStyle(
            //         color: Constants.darkBlue,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 30)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Uploaded by',
                              style: TextStyle(
                                  color: Constants.darkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Spacer(),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3, color: Colors.pink.shade700),
                              shape: BoxShape.circle,
                              image: authorImageUrl == null
                                  ? DecorationImage(
                                      image: AssetImage(
                                          'assets/images/placeholder_user_01.png'),
                                      fit: BoxFit.fill)
                                  : DecorationImage(
                                      image: NetworkImage(authorImageUrl!),
                                      fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(authorName == null ? 'N/A' : authorName!,
                                  style: _textStyle),
                              Text(
                                  authorJobTitle == null
                                      ? 'N/A'
                                      : authorJobTitle!,
                                  style: _textStyle),
                            ],
                          )
                        ],
                      ),
                      _dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Uploaded on:', style: _titleStyle),
                          Text(postedDate == null ? 'N/A' : postedDate!,
                              style: TextStyle(
                                  color: Constants.darkBlue,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Deadline date:', style: _titleStyle),
                          Text(deadlineDate == null ? 'N/A' : deadlineDate!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                            isDeadlineAvailable
                                ? 'Still have time'
                                : 'Deadline passed',
                            style: TextStyle(
                                color: isDeadlineAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      ),
                      _dividerWidget(),
                      Text('Done state:', style: _titleStyle),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _isDoneState(true),
                            child: Text('Done',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Constants.darkBlue,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Opacity(
                            opacity: _isDone == true ? 1 : 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 40),
                          TextButton(
                            onPressed: () => _isDoneState(false),
                            child: Text('Not Done',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Constants.darkBlue,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Opacity(
                            opacity: _isDone == false ? 1 : 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      _dividerWidget(),
                      Text('Task descriprtion:', style: _titleStyle),
                      SizedBox(height: 10),
                      Text(taskDescription == null ? '' : taskDescription!,
                          style: _textStyle),
                      SizedBox(height: 40),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      style:
                                          TextStyle(color: Constants.darkBlue),
                                      keyboardType: TextInputType.multiline,
                                      maxLength: 200,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.pink)),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            if (_commentController.text.length <
                                                7) {
                                              GlobalMethod.showErrorDialog(
                                                  ctx: context,
                                                  error:
                                                      "Comment can't be less than 7 characters");
                                            } else {
                                              final _commentId = Uuid().v4();
                                              await FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(widget.taskId)
                                                  .update({
                                                'taskComments':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'commenterId':
                                                        widget.userId,
                                                    'commenterName':
                                                        widget.userFullName,
                                                    'commenterImageUrl':
                                                        widget.userImageUrl,
                                                    // 'userFullName':_userFullName,
                                                    // 'userImageUrl':_userImageUrl,
                                                    'commentId': _commentId,
                                                    'commentBody':
                                                        _commentController.text,
                                                    'commentDateTimeStamp':
                                                        Timestamp.now(),
                                                  }
                                                ]),
                                              });
                                              await Fluttertoast.showToast(
                                                  msg:
                                                      "Comment has been posted",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  fontSize: 18.0);
                                              _commentController.clear();
                                              setState(() => _isCommenting =
                                                  !_isCommenting);
                                            }
                                          },
                                          color: Colors.pink.shade700,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            'Post',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () => setState(() =>
                                              _isCommenting = !_isCommenting),
                                          child: Text('Cancel'))
                                    ],
                                  ))
                                ],
                              )
                            : Center(
                                child: MaterialButton(
                                  onPressed: () => setState(
                                      () => _isCommenting = !_isCommenting),
                                  color: Colors.pink.shade700,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      'Post a comment',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 40),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.taskId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Text('No comment posted yet');
                            } else {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.data == null) {
                                  return Text('No comment posted yet');
                                } else {
                                  // print('commented');
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          snapshot.data!['taskComments'].length,
                                      itemBuilder: (context, index) {
                                        return CommentWidget(
                                          // commentId: snapshot.data!['taskComments'][index]['commentId'],
                                          commentBody:
                                              snapshot.data!['taskComments']
                                                  [index]['commentBody'],
                                          commenterId:
                                              snapshot.data!['taskComments']
                                                  [index]['commenterId'],
                                          commenterName:
                                              snapshot.data!['taskComments']
                                                  [index]['commenterName'],
                                          commenterImageUrl:
                                              snapshot.data!['taskComments']
                                                  [index]['commenterImageUrl'],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(thickness: 1);
                                      });
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              // return Center(child: CircularProgressIndicator());
                            }
                            // if (snapshot.connectionState ==
                            //     ConnectionState.waiting) {
                            //   return Center(child: CircularProgressIndicator());
                            // } else {
                            //   if (snapshot.data == null) {
                            //     return Text('No comment posted yet');
                            //   }
                            // }

                            // itemCount:snapshot.data!['taskComments'].length);
                          }),
                      // FutureBuilder<DocumentSnapshot>(
                      //     future: FirebaseFirestore.instance
                      //         .collection('tasks')
                      //         .doc(widget.taskId)
                      //         .get(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return Center(child: CircularProgressIndicator());
                      //       } else {
                      //         if (snapshot.data == null) {
                      //           return Text('No comment posted yet');
                      //         }
                      //       }
                      //       return ListView.separated(
                      //           shrinkWrap: true,
                      //           physics: NeverScrollableScrollPhysics(),
                      //           itemBuilder: (context, index) {
                      //             return CommentWidget(
                      //               // commentId: snapshot.data!['taskComments'][index]['commentId'],
                      //               commentBody: snapshot.data!['taskComments']
                      //                   [index]['commentBody'],
                      //               commenterId: snapshot.data!['taskComments']
                      //                   [index]['commenterId'],
                      //               commenterName:
                      //                   snapshot.data!['taskComments'][index]
                      //                       ['commenterName'],
                      //               commenterImageUrl:
                      //                   snapshot.data!['taskComments'][index]
                      //                       ['commenterImageUrl'],
                      //             );
                      //           },
                      //           separatorBuilder: (context, index) {
                      //             return Divider(thickness: 1);
                      //           },
                      //           itemCount:
                      //               snapshot.data!['taskComments'].length);
                      //     }),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dividerWidget() => Column(
        children: [
          SizedBox(height: 10),
          Divider(thickness: 1),
          SizedBox(height: 10),
        ],
      );
}
