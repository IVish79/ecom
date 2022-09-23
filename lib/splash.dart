import 'package:ecom/Utils.dart';
import 'package:ecom/homepage.dart';
import 'package:ecom/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gonext();
  }

  gonext() async {

    Utils.prefs = await SharedPreferences.getInstance();

    bool loginstatus = Utils.prefs!.getBool("loginstatus") ?? false;

    if(loginstatus)
      {
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return homepage();
          },
        ));
      }
    else
      {
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return loginpage();
          },
        ));
      }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xD660AE98),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFFFFFFFF),
              valueColor: AlwaysStoppedAnimation(Color(0xFF060505)),
              strokeWidth: 5,
            ),
          ),
        ));
  }
}
