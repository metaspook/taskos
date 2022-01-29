import 'package:flutter/material.dart';
import 'package:taskos/utils/constants.dart';

class Methods {
  static void showErrorDialog(
      {required BuildContext ctx, required String error}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/1252/1252006.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Error occured'),
                )
              ],
            ),
            content: Text(
              '$error',
              style: TextStyle(
                color: Constants.darkBlue,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // Navigator.canPop(context) ? Navigator.pop(context) : null,
                    if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                  },
                  child: Text('OK', style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }
}
