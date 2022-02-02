import 'package:flutter/material.dart';
import 'package:taskos/pages/inner/profile.dart';
import 'package:taskos/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String userJobTitle;
  final String userPhoneNumber;
  final String? userImageUrl;

  const AllWorkersWidget(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.userJobTitle,
      required this.userPhoneNumber,
      required this.userImageUrl})
      : super(key: key);
  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(userId: widget.userId))),
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
            child: widget.userImageUrl == null
                ? Image.asset('assets/images/placeholder_user_01.png')
                : Image.network(widget.userImageUrl!),
          ),
        ),
        title: Text(
          widget.userName,
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
              '${widget.userJobTitle}/${widget.userPhoneNumber}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.mail_outline,
            size: 30,
            color: Colors.pink.shade800,
          ),
          onPressed: () => _launchUrl('mailto:${widget.userEmail}'),
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async =>
      await canLaunch(url) ? await launch(url) : throw "Couldn't launch: $url";
}
