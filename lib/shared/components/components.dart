import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

Widget dividerSeparator() => Divider(
      thickness: 0.3,
      color: MyColors.dark,
    );

//<editor-fold desc='Default FormField'>
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  String? Function(String?)? validate,
  VoidCallback? onPressed,
  Function(String?)? onChanged,
  required IconData prefixIcon,
  double borderRadius = 0,
  String? hint,
  IconData? suffixIcon,
  bool isPassword = false,
  required bool isRtl,
  Color color = Colors.black,
  Color textColor = Colors.white,
}) =>
    TextFormField(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      controller: controller,
      style: TextStyle(
        color: textColor,
      ),
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: new BorderSide(color: Colors.blue),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: color,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  suffixIcon,
                ),
              )
            : null,
      ),
      validator: validate,
      onChanged: onChanged,
      onTap: onPressed,
    );
//</editor-fold>

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateToFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
