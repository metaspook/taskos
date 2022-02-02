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
                  child: Image.asset(
                    'assets/images/exit_00.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Error occured'),
                )
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(
                color: Constants.darkBlue,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                  },
                  child: const Text('OK', style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }
}
