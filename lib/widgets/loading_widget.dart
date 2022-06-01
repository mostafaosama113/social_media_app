import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget loadingWidget() {
  return Container(
    color: Colors.transparent,
    child: Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          height: 100.h,
          width: 100.w,
          color: Colors.white,
          child: Lottie.asset(
            'assets/lottiefiles/loading.json',
            height: 100.h,
            width: 100.w,
          ),
        ),
      ),
    ),
  );
}
