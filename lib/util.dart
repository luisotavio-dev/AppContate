import 'package:flutter/material.dart';

class Util {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackMessage(String error, context, {double maxHeight = 13}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: Container(
          constraints: BoxConstraints(minHeight: 13, maxHeight: maxHeight),
          child: Center(child: Text(error)),
        ),
      ),
    );
  }
}
