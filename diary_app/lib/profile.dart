import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setting"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Comment Icon',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent[200],
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu Icon',
          onPressed: () {},
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<dynamic>(
        future: fetchData(),
        builder: (context, snapshot) {
          final instanceData = snapshot.data;
          if (snapshot.hasData) {
            // Data fetched successfully, display it
            return Column(
              children: [
                Text("Name " + instanceData['name']),
                Text("Email " + instanceData['email']),
                Text("ID " + instanceData['pstu_id']),
                Text("Registration " + instanceData['registration']),
                Text("Blood Group " + instanceData['blood_group']),
              ],
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
