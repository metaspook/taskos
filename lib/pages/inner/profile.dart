import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:taskos/user_state.dart';
import 'package:taskos/utils/constants.dart';
import 'package:taskos/widgets/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _titleTextStyle = const TextStyle(
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  final _contantTextStyle = const TextStyle(
    color: Constants.darkBlue,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false;
  String userPhoneNumber = '';
  String userEmail = '';
  String? userFullName;
  String userJobTitle = '';
  String? userImageUrl;
  String joiningDate = '';
  bool _isSameUser = false;
  Future<void> getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot? userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          userEmail = userDoc.get('userEmail');
          userFullName = userDoc.get('userFullName');
          userJobTitle = userDoc.get('userJobTitle');
          userPhoneNumber = userDoc.get('userPhoneNumber');
          userImageUrl = userDoc.get('userImageUrl');
          Timestamp joiningDateTimeStamp = userDoc.get('creationDateTimeStamp');
          var joiningDateTime = joiningDateTimeStamp.toDate();
          joiningDate =
              '${joiningDateTime.year}-${joiningDateTime.month}-${joiningDateTime.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (err) {
      print(err);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 100),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                  userFullName == null
                                      ? 'FullName here'
                                      : userFullName!,
                                  style: _titleTextStyle)),
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                  '$userJobTitle Since joined $joiningDate',
                                  style: _contantTextStyle)),
                          const SizedBox(height: 15),
                          const Divider(thickness: 1),
                          const SizedBox(height: 20),
                          Text('Contact Info', style: _titleTextStyle),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child:
                                userInfo(title: 'Email:', contant: userEmail),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: userInfo(
                                title: 'Phone number:',
                                contant: userPhoneNumber),
                          ),
                          const SizedBox(height: 15),
                          const Divider(thickness: 1),
                          const SizedBox(height: 20),
                          _isSameUser
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _contactBy(
                                        color: Colors.green,
                                        fct: () => _launchUrl(
                                            'https://wa.me/$userPhoneNumber?text=Hello%20World'),
                                        icon: FontAwesome.whatsapp),
                                    _contactBy(
                                        color: Colors.red,
                                        fct: () =>
                                            _launchUrl('mailto:$userEmail'),
                                        icon: Icons.mail_outline),
                                    _contactBy(
                                        color: Colors.purple,
                                        fct: () => _launchUrl(
                                            'tel://$userPhoneNumber'),
                                        icon: Icons.call_outlined),
                                  ],
                                ),
                          const SizedBox(height: 25),
                          _isSameUser
                              ? Container()
                              : const Divider(thickness: 1),
                          _isSameUser
                              ? Container()
                              : const SizedBox(height: 25),
                          !_isSameUser
                              ? Container()
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: MaterialButton(
                                      onPressed: () {
                                        _auth.signOut();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserState(),
                                            ));
                                      },
                                      color: Colors.pink.shade700,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.logout,
                                                color: Colors.white),
                                            SizedBox(width: 8),
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.26,
                        height: size.width * 0.26,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 8,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          image: DecorationImage(
                              image: NetworkImage(userImageUrl == null
                                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                  : userImageUrl!),
                              fit: BoxFit.fill),
                        ),
                      )
                    ],
                  )
                ],
              ),
              // ),
            ),
    );
  }

  Future<void> _launchUrl(url) async =>
      await canLaunch(url) ? await launch(url) : throw "Couldn't launch: $url";

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () => fct(),
          )),
    );
  }

  Widget userInfo({required String title, required String contant}) {
    return Row(
      children: [
        Text(title, style: _titleTextStyle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(contant, style: _contantTextStyle),
        ),
      ],
    );
  }
}
