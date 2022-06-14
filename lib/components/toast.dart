import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';

void toast(String title) {
  showToast(
    title,
    duration: const Duration(milliseconds: 1700),
    textPadding: defaultPadding,
    textStyle: const TextStyle(
      fontSize: 16,
    ),
    position: ToastPosition.bottom,
  );
}
