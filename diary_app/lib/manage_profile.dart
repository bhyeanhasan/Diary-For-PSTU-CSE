import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pstu_idController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _blood_groupController = TextEditingController();
  final TextEditingController _addresspController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  Future<dynamic> fetchData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final headers = {
      'Authorization': 'Token $token',
    };

    final response = await http.get(
      Uri.parse('http://192.168.0.105:8000/user-profile/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('sdfsdf');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateProfile() async {
    final apiUrl = 'http://192.168.0.105:8000/profile/';

    final updatedProfile = {
      'name': _nameController.text,
      'email': _emailController.text,
      'pstu_id': _pstu_idController.text,
      'registration': _registrationController.text,
      'blood_group': _blood_groupController.text,
      'address': _addresspController.text,
      'facebook': _facebookController.text,
      'twitter': _twitterController.text,
      'linkedin': _linkedinController.text,
    };

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(updatedProfile),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setting"),
        actions: <Widget>[
          Text("Logout"),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Comment Icon',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent[200],
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Menu Icon',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<dynamic>(
        future: fetchData(),
        builder: (context, snapshot) {
          final instanceData = snapshot.data;

          _nameController.text = instanceData['name'];
          _emailController.text = instanceData['email'];
          _pstu_idController.text = instanceData['pstu_id'];
          _registrationController.text = instanceData['registration'];
          _blood_groupController.text = instanceData['blood_group'];
          _addresspController.text = instanceData['address'];
          _facebookController.text = instanceData['facebook'];
          _twitterController.text = instanceData['twitter'];
          _linkedinController.text = instanceData['linkedin'];

          if (snapshot.hasData) {
            // Data fetched successfully, display it
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _pstu_idController,
                        decoration: InputDecoration(labelText: 'ID'),
                      ),
                      TextField(
                        controller: _registrationController,
                        decoration: InputDecoration(labelText: 'Registration'),
                      ),
                      TextField(
                        controller: _blood_groupController,
                        decoration: InputDecoration(labelText: 'Blood Group'),
                      ),
                      TextField(
                        controller: _addresspController,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      TextField(
                        controller: _facebookController,
                        decoration: InputDecoration(labelText: 'Facebook'),

                      ),
                      TextField(
                        controller: _linkedinController,
                        decoration: InputDecoration(labelText: 'LinkedIn'),
                      ),
                      TextField(
                        controller: _twitterController,
                        decoration: InputDecoration(labelText: 'Mobile'),
                      ),

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: updateProfile,
                        child: Text('Post Data'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Error occurred while fetching data
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          // Data is being fetched
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
