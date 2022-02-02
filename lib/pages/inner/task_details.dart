import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskos/services/methods.dart';
import 'package:taskos/utils/constants.dart';
import 'package:taskos/widgets/comment_widget.dart';
import 'package:uuid/uuid.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({
    Key? key,
    required this.userId,
    required this.userFullName,
    required this.userImageUrl,
    required this.taskId,
    required this.authorId,
  }) : super(key: key);
  final String userId;
  final String userFullName;
  final String userImageUrl;
  final String taskId;
  final String authorId;

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _textStyle = const TextStyle(
      color: Constants.darkBlue, fontSize: 13, fontWeight: FontWeight.normal);
  final _titleStyle = const TextStyle(
      color: Constants.darkBlue, fontWeight: FontWeight.bold, fontSize: 20);
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  bool isDeadlineAvailable = false;
  bool? _isDone;
  String? authorName;
  String? authorJobTitle;
  String? authorImageUrl;
  String? taskTitle;
  String? taskCategory;
  String? taskDescription;
  String? postedDate;
  String? deadlineDate;
  Timestamp? creationDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;

  @override
  void initState() {
    super.initState();
    getTaskData();
  }

  Future<void> getTaskData() async {
    final DocumentSnapshot? userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.authorId)
        .get();
    if (userDoc != null) {
      setState(() {
        authorName = userDoc.get('userFullName');
        authorJobTitle = userDoc.get('userJobTitle');
        authorImageUrl = userDoc.get('userImageUrl');
      });
    }
    final DocumentSnapshot? taskDoc = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    if (taskDoc != null) {
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
    }
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
            .catchError((error) => Methods.showErrorDialog(
                ctx: context, error: "Action can't be performed"))
        : Methods.showErrorDialog(
            ctx: context, error: "You can't perform this action");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          taskTitle == null ? 'N/A' : taskTitle!,
          style: const TextStyle(
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
                          const Text('Uploaded by',
                              style: TextStyle(
                                  color: Constants.darkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const Spacer(),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3, color: Colors.pink.shade700),
                              shape: BoxShape.circle,
                              image: authorImageUrl == null
                                  ? const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/placeholder_user_01.png'),
                                      fit: BoxFit.fill)
                                  : DecorationImage(
                                      image: NetworkImage(authorImageUrl!),
                                      fit: BoxFit.fill),
                            ),
                          ),
                          const SizedBox(width: 5),
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
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Deadline date:', style: _titleStyle),
                          Text(deadlineDate == null ? 'N/A' : deadlineDate!,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _isDoneState(true),
                            child: const Text('Done',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Constants.darkBlue,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Opacity(
                            opacity: _isDone == true ? 1 : 0,
                            child: const Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 40),
                          TextButton(
                            onPressed: () => _isDoneState(false),
                            child: const Text('Not Done',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Constants.darkBlue,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Opacity(
                            opacity: _isDone == false ? 1 : 0,
                            child: const Icon(
                              Icons.check_box,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      _dividerWidget(),
                      Text('Task descriprtion:', style: _titleStyle),
                      const SizedBox(height: 10),
                      Text(taskDescription == null ? '' : taskDescription!,
                          style: _textStyle),
                      const SizedBox(height: 40),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      style: const TextStyle(
                                          color: Constants.darkBlue),
                                      keyboardType: TextInputType.multiline,
                                      maxLength: 200,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                        focusedBorder: const OutlineInputBorder(
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
                                              Methods.showErrorDialog(
                                                  ctx: context,
                                                  error:
                                                      "Comment can't be less than 7 characters");
                                            } else {
                                              final _commentId =
                                                  const Uuid().v4();
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
                                          child: const Text(
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
                                          child: const Text('Cancel'))
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
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
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
                      const SizedBox(height: 40),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Text('No comment posted yet');
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.data == null) {
                                return const Text('No comment posted yet');
                              } else {
                                // print('commented');
                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                      return const Divider(thickness: 1);
                                    });
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 5),
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

  Widget _dividerWidget() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(thickness: 1),
        SizedBox(height: 10),
      ],
    );
  }
}
