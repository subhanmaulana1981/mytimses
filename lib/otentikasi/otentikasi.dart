import 'package:flutter/material.dart';
import 'package:mytimses/otentikasi/signin.dart';
import 'package:mytimses/otentikasi/signup.dart';

class Otentikasi extends StatefulWidget {
  const Otentikasi({Key? key}) : super(key: key);

  @override
  State<Otentikasi> createState() => _OtentikasiState();
}

class _OtentikasiState extends State<Otentikasi> {

  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    // function properties as parameters
    if(showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
