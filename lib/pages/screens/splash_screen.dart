import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../home_screen.dart';
import './introduction_screen.dart';
import '../../utils/app_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await Future.delayed(Duration(seconds: 2));
    if (appProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => IntroductionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 200),
              Image.asset(
                'assets/images/logo.png',
                width: 275,
                height: 275,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 175),
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.indigo,
                size: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
