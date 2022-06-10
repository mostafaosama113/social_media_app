import 'package:flutter/material.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.hint,
    this.isPass = false,
    this.icon,
    this.inputType = TextInputType.text,
    required this.controller,
    this.maxLen,
  }) : super(key: key);
  final String hint;
  final bool isPass;
  final TextEditingController controller;
  final IconData? icon;
  final TextInputType inputType;
  final int? maxLen;
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: SizedBox(
        height: 60.h,
        child: TextField(
          maxLength: widget.maxLen,
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: widget.isPass,
          style: defaultTextStyle,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: widget.icon == null ? null : Icon(widget.icon),
            hintText: widget.hint,
            hintStyle: defaultTextStyle,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: MyColor.blue,
                )),
          ),
        ),
      ),
    );
  }
}
