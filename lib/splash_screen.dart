import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'Helper.dart';
import 'HomeScreen.dart';
import 'phone.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    _navigattohome();
  }

  _navigattohome() async {
    await Future.delayed(Duration(seconds: 3));
    bool islogin = await Helper.getLoginStatus();
    if (!islogin)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => phone()));
    else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo2.png',
              height: size.height * 0.35,
              width: size.width * 0.7,
            ),
            FadeInUp(
              child: Text(
                'Welcome to Task Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
