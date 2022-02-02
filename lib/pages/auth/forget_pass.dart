import 'package:flutter/material.dart';
import 'package:taskos/widgets/translucent_background.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  // TextEditingController must initialize either leads to error.
  late TextEditingController _forgetPassTextController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _forgetPassTextController.dispose();
    super.dispose();
  }

  void _forgetPassFCT() {
    // will print the inputs of text field in debug console.
    print('_forgetPassTextController.text ${_forgetPassTextController.text}');
  }

  @override
  Widget build(BuildContext context) {
    // Get the size from resposiveness
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Colors.blue,
        body: TranslucentBackground(
      blurFilter: const [2, 2],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              'Forget password',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Email address',
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _forgetPassTextController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 60),
            MaterialButton(
              onPressed: _forgetPassFCT,
              color: Colors.pink.shade700,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Reset now',
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
