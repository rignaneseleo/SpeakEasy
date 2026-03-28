import 'package:fluttertoast/fluttertoast.dart';
import 'package:speakeasy/theme/app_theme.dart';

void showToast(String text) => Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.darkPurple,
      textColor: AppColors.txtWhite,
      fontSize: 16.0,
    );
