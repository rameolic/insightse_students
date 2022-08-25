import 'package:flutter/material.dart';
import 'sign_in/sign_in.dart';
import 'style.dart' as styles;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSMS App',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: styles.Style.buttonColor,
        // ignore: deprecated_member_use
        cursorColor: styles.Style.buttonColor,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.yellow[600],
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: styles.Style.buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          highlightColor: styles.Style.buttonHighlightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      home: SignIn(),
    );
  }
}
