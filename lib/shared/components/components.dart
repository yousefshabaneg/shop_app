import 'package:bot_toast/bot_toast.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

Widget dividerSeparator() => Divider(
      thickness: 0.3,
      color: MyColors.dark,
    );

//<editor-fold desc='Default Button'>
Widget defaultButton({
  required String text,
  required VoidCallback onPressed,
  double height = 60,
  double width = double.infinity,
  Color background = Colors.red,
  Color textColor = Colors.white,
  double radius = 0.0,
  bool isUpperCase = true,
  double fontSize = 18,
  border,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressed,
        height: height,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border,
        color: background,
      ),
    );
//</editor-fold>

//<editor-fold desc='Default FormField'>
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  String? Function(String?)? validate,
  VoidCallback? onTap,
  ValueChanged<String>? onSubmit,
  VoidCallback? suffixPressed,
  Function(String?)? onChanged,
  required IconData prefixIcon,
  double borderRadius = 20,
  required String label,
  IconData? suffixIcon,
  bool isPassword = false,
  // required bool isRtl,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: new BorderSide(color: Colors.blue),
        ),
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffixIcon,
                ),
              )
            : null,
      ),
      validator: validate,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
    );
//</editor-fold>

Widget buildProgressIndicator() => Center(child: CircularProgressIndicator());

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );

void showToast({
  required String msg,
  required ToastStates state,
  double fontSize = 16,
  int seconds = 5,
}) =>
    BotToast.showText(
        text: msg,
        duration: Duration(seconds: seconds),
        contentColor: toastColor(state),
        clickClose: true,
        align: Alignment(0, -0.9));

enum ToastStates { SUCCESS, ERROR, WARNING }

Color toastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.ERROR:
      return Colors.red;
    case ToastStates.WARNING:
      return Colors.yellow;
  }
}

// Widget myDivider() => Padding(
//       padding: const EdgeInsetsDirectional.only(
//         start: 20.0,
//       ),
//       child: Container(
//         width: double.infinity,
//         height: 1.0,
//         color: Colors.grey[300],
//       ),
//     );

Widget divider() => Divider(
      color: MyColors.grey,
      height: 20,
      thickness: 0.5,
      indent: 0,
      endIndent: 0,
    );
Widget buildIconWithNumber({
  required bool condition,
  number,
  icon,
  iconColor,
  double size = 30,
  double radius = 12,
  double fontSize = 13,
  VoidCallback? onPressed,
  alignment = const Alignment(1.6, -0.8),
}) =>
    Column(
      children: [
        Stack(
          alignment: alignment,
          children: [
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: iconColor,
                size: size,
              ),
            ),
            if (condition)
              CircleAvatar(
                radius: radius,
                backgroundColor: MyColors.secondary,
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );

Text iconText(text) => Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
    );
