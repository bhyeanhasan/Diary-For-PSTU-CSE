import 'package:flutter/material.dart';
import '../manage_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _announcementController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String announcement = _announcementController.text;

      const String apiUrl = 'http://192.168.0.105:8000/mail/';

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{'announcement': announcement}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Successfully Send",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pinkAccent[200],
              ),
              child: const Text(
                'Give An Announcement',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.white,
                width: double.infinity,
                height: 550,
                child: Column(
                  children: [

                    TextFormField(
                      controller: _announcementController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      maxLines: 10,
                      decoration: InputDecoration(labelText: 'Announcement'),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
