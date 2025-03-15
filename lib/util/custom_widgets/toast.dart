import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class Dialogues {
  static void toast(String msg, {bool isError = false}) {
    showToast(
      msg,
      position: ToastPosition.top,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      textPadding: const EdgeInsets.all(10),
      radius: 4,
      backgroundColor: isError
          ? Colors.red
          : Colors.white,
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 200),
      textStyle: TextStyle(
          color: Colors.black,
          fontSize: 16),
    );
  }
}
