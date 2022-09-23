import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'loginpage.dart';

class registerpage extends StatefulWidget {
  const registerpage({Key? key}) : super(key: key);

  @override
  State<registerpage> createState() => _registerpageState();
}

class _registerpageState extends State<registerpage> {
  TextEditingController tname = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tcontact = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  String imagepath = "";

  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return loginpage();
            },
          ));
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Register"),
      ),
      body: ListView(
        children: [
          Container(
            height: 150,
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Choose Image"),
                      children: [
                        ListTile(
                          title: Text("Camera"),
                          onTap: () async {
                            XFile? image = await _picker.pickImage(
                                source: ImageSource.camera);

                            if (image != null) {
                              setState(() {
                                imagepath = image.path;
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Text("Camera"),
                          onTap: () async {
                            XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);

                            if (image != null) {
                              setState(() {
                                imagepath = image.path;
                              });
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 140,
                width: 140,
                child: imagepath.isEmpty
                    ? Image.asset("myimages/user.png")
                    : Image.file(File(imagepath)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: tname,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: temail,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: tcontact,
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
          ElevatedButton(
              onPressed: () async {
                String name = tname.text;
                String email = temail.text;
                String contact = tcontact.text;
                String password = tpassword.text;

                // Imagepath and Imagename

                DateTime dt = DateTime.now();

                String filename =
                    "$name${dt.year}${dt.month}${dt.day}${dt.hour}${dt
                    .minute}${dt.second}.jpg";

                var formData = FormData.fromMap({
                  'name': name,
                  'email': email,
                  'contact': contact,
                  'password': password,
                  'file': await MultipartFile.fromFile(
                      imagepath, filename: filename),
                });

                var response = await Dio().post(
                    'https://cdmidevelopment.000webhostapp.com/Ecom/ecom_insert.php',
                    data: formData);

                print(response.data);

                Map map = jsonDecode(response.data);

                int status = map['status'];

                if (status == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Sorry! Try again.")));
                }
                else if (status == 1) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return loginpage();
                    },
                  ));
                }
                if (status == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User already exists.")));
                }
              },
              child: Text("Register"))
        ],
      ),
    ), onWillPop: backPress);
  }

 Future<bool> backPress()
  {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return loginpage();
      },
    ));
    return Future.value();
  }
}
