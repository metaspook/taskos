import 'package:TaskOS/inner_screens/profile.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  // final String commentId;
  final String commentBody;
  final String commenterId;
  final String commenterName;
  final String? commenterImageUrl;

  const CommentWidget({
    // required this.commentId,
    required this.commentBody,
    required this.commenterId,
    required this.commenterName,
    required this.commenterImageUrl,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blue,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(userId: widget.commenterId))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1, //Default flex is 1 even if not specified.
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: _colors[1]),
                shape: BoxShape.circle,
                image: widget.commenterImageUrl == null
                    ? DecorationImage(
                        image:
                            AssetImage('assets/images/placeholder_user_01.png'),
                        fit: BoxFit.fill)
                    : DecorationImage(
                        image: NetworkImage(widget.commenterImageUrl!),
                        fit: BoxFit.fill),
              ),
            ),
          ),
          SizedBox(width: 6),
          Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.commenterName,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    widget.commentBody,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
