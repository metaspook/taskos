import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskos/pages/all_tasks.dart';
import 'package:taskos/services/methods.dart';
import 'package:taskos/utils/constants.dart';
import 'package:taskos/widgets/drawer_widget.dart';
import 'package:uuid/uuid.dart';

class TaskUpload extends StatefulWidget {
  @override
  _TaskUploadState createState() => _TaskUploadState();
}

class _TaskUploadState extends State<TaskUpload> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _taskCategoryController =
      TextEditingController(text: 'Choose task Category');
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _deadlineDateController =
      TextEditingController(text: 'Choose task Deadline date');
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? _deadlineDateTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _taskCategoryController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _deadlineDateController.dispose();
  }

  Future<void> _uploadTask() async {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final _taskId = Uuid().v4();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_deadlineDateController.text == 'Choose task Deadline date' ||
          _taskCategoryController.text == 'Choose task Category') {
        Methods.showErrorDialog(ctx: context, error: 'Please pick everything');
        // return;
      } else {
        setState(() => _isLoading = true);
        try {
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(_taskId)
              .set({
            'taskId': _taskId,
            'taskTitle': _taskTitleController.text,
            'taskDescription': _taskDescriptionController.text,
            'taskCategory': _taskCategoryController.text,
            'taskComments': [],
            'deadlineDate': _deadlineDateController.text,
            'deadlineDateTimeStamp': _deadlineDateTimeStamp,
            'authorId': _uid,
            'isDone': false,
            'creationDateTimeStamp': Timestamp.now(),
          });
          await Fluttertoast.showToast(
              msg: "The task has been uploaded",
              toastLength: Toast.LENGTH_SHORT,
              // gravity: ToastGravity.CENTER,
              // timeInSecForIosWeb: 1,
              // backgroundColor: Colors.red,
              // textColor: Colors.white,
              fontSize: 18.0);
          // _taskTitleController.clear();
          // _taskDescriptionController.clear();
          // setState(() {
          //   _taskCategoryController.text = 'Choose task Category';
          //   _deadlineDateController.text = 'Choose task Deadline date';
          // });
        } catch (error) {
        } finally {
          // setState(() => _isLoading = false);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllTasksPage(),
              ));
        }
      }
    } else {
      print('It is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                // Align(
                //   // alignment: Alignment.center,
                //   child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'All Fields are required',
                    style: TextStyle(
                      color: Constants.darkBlue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ),
                SizedBox(height: 10),
                Divider(
                  thickness: 1,
                ),
                // SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        _textTitles(label: 'Task Category*'),
                        _textFormField(
                          valueKey: 'TaskCategory',
                          controller: _taskCategoryController,
                          enabled: false,
                          fct: () => _taskCategoryDialog(size: size),
                        ),
                        SizedBox(height: 20),
                        // Title
                        _textTitles(label: 'Task Title*'),
                        _textFormField(
                            valueKey: 'TaskTitle',
                            controller: _taskTitleController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100),
                        // Description
                        _textTitles(label: 'Task Description*'),
                        _textFormField(
                            valueKey: 'TaskDescription',
                            controller: _taskDescriptionController,
                            enabled: true,
                            fct: () {},
                            maxLength: 1000),
                        // Deadline date
                        _textTitles(label: 'Task Deadline date*'),

                        _textFormField(
                          valueKey: 'TaskDeadline',
                          controller: _deadlineDateController,
                          enabled: false,
                          fct: _pickDateDialog,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Center(
                //   child:
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                          onPressed: _uploadTask,
                          color: Colors.pink.shade700,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Upload Task',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.upload_file, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => fct(),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          // initialValue: 'Hello',
          style: TextStyle(
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.pink,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _taskCategoryDialog({required Size size}) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Task category',
            style: TextStyle(fontSize: 20, color: Colors.pink.shade800),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: Constants.taskCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _taskCategoryController.text =
                            Constants.taskCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.red.shade200,
                        ),
                        // SizedBox(width: 10),
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
                onPressed: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Text('Cancel'))
          ],
        );
      },
    );
  }

  Future<void> _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(2100),
    );
    if (picked != null)
      setState(() {
        _deadlineDateController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
        // Normal date to timestamp conversion.
        _deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
  }

  Widget _textTitles({required String label}) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.pink[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
