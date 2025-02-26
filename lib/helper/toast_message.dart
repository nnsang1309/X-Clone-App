import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, failed }

class ToastMessage {
  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");

    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse(hex, radix: 16));
  }

  showToast(
    String text,
    ToastType type,
  ) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: type == ToastType.failed ? Colors.red : ToastMessage().hexToColor('#2ecc71'),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
