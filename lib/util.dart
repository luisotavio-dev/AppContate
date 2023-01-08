import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

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

  static DateTime setHourToDateTime(DateTime dateTime, int hour, int minutes, int secounds) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minutes, secounds);
  }

  static Future<Uint8List> logoAppRelatorios() async {
    ByteData bytes = await rootBundle.load('assets/img/logomarca.png');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  static Future<Uint8List> logoLMSoftwaresRelatorios() async {
    ByteData bytes = await rootBundle.load('assets/img/logomarca-lmsoftwares.png');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
