import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecom/Utils.dart';
import 'package:ecom/homepage.dart';
import 'package:ecom/registerpage.dart';
import 'package:flutter/material.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  TextEditingController tusername = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginPage"),
      ),
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tusername,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tpassword,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              ElevatedButton(onPressed: () async {

                String username = tusername.text;
                String password = tpassword.text;

                String api = 'https://cdmidevelopment.000webhostapp.com/Ecom/ecom_view.php?username=$username&password=$password';
                Response response = await Dio().get(api);

                print(response.data);

                Map map = jsonDecode(response.data);

                int status = map['status'];

                if (status == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid Username or Password")));
                }
                else if (status == 1) {

                  Map userdata = map['userdata'];

                  User user = User.fromJson(userdata);


                  await Utils.prefs!.setBool('loginstatus', true);

                  await Utils.prefs!.setString('id', user.id!);
                  await Utils.prefs!.setString('name', user.name!);
                  await Utils.prefs!.setString('email', user.email!);
                  await Utils.prefs!.setString('contact', user.contact!);
                  await Utils.prefs!.setString('password', user.password!);
                  await Utils.prefs!.setString('imagepath', user.imagepath!);

                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return homepage();
                    },
                  ));
                }

              }, child: Text("Login"))
            ],
          )),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return registerpage();
                },
              ));
            },
            child: Container(
              height: 45,
              width: double.infinity,
              color: Color(0xFFE7E7E7),
              alignment: Alignment.center,
              child: Text("Not Register? Register"),
            ),
          )
        ],
      ),
    );
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? contact;
  String? password;
  String? imagepath;

  User(
      {this.id,
        this.name,
        this.email,
        this.contact,
        this.password,
        this.imagepath});

  User.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    password = json['password'];
    imagepath = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['password'] = this.password;
    data['imagepath'] = this.imagepath;
    return data;
  }
}
