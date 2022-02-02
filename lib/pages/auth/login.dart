import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskos/pages/auth/forget_pass.dart';
import 'package:taskos/pages/auth/register.dart';
import 'package:taskos/services/methods.dart';
import 'package:taskos/widgets/translucent_background.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextEditingController must initialize either leads to error.
  late TextEditingController _emailTextController =
      TextEditingController(text: '');
  late TextEditingController _passTextController =
      TextEditingController(text: '');
  FocusNode _passFocusNode = FocusNode();
  bool _obsecureText = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
  }

  Future<void> _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() => _isLoading = true);
    }
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim());
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (error) {
      setState(() => _isLoading = false);
      Methods.showErrorDialog(ctx: context, error: error.toString());
      print('error occured $error');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Get the size from resposiveness
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Colors.blue,
        body:
            // Stack(
            // children: [
            //   Image.asset(
            //     'assets/images/auth_background.jpg',
            //     width: double.infinity,
            //     height: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // CachedNetworkImage(
            //   // "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            //   imageUrl:
            //       "https://images.pexels.com/photos/2793175/pexels-photo-2793175.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
            //   placeholder: (context, url) => Image.asset(
            //     'assets/images/auth_background_fallback.jpg',
            //     fit: BoxFit.fill,
            //   ),
            //   errorWidget: (context, url, error) => const Icon(Icons.error),
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            //   alignment: FractionalOffset(_animation.value, 0),
            // ),
            TranslucentBackground(
      blurFilter: const [2, 2],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(text: '    '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp())),
                    text: "Register",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _loginFormKey,
              child: Column(children: [
                // Email
                TextFormField(
                  // Will add a '@' button in virtual keyboard.
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passFocusNode),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextController,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid Email address';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Password
                TextFormField(
                  focusNode: _passFocusNode,
                  obscureText: _obsecureText,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passTextController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Please enter a valid password';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Icon(
                          _obsecureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        )),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgetPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Forget password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic),
                  )),
            ),
            SizedBox(height: 40),
            MaterialButton(
              onPressed: _submitFormOnLogin,
              color: Colors.pink.shade700,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.login, color: Colors.white)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )
        // ],
        // ),
        );
  }
}
