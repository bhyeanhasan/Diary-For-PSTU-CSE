import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'profile.dart';
import 'manage_profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> fetchData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final headers = {
      'Authorization': 'Token $token',
    };
    final response = await http.get(
      Uri.parse('http://192.168.0.105:8000/profile/'),
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
        title: const Text("CSE DIARY"),
        actions: <Widget>[
          const Text("Profile"),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile Icon',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostPage()));
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent[200],
        elevation: 50.0,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   tooltip: 'Menu Icon',
        //   onPressed: () { },
        // ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pinkAccent[200],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Add your logic for Button 1 here
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostPage()));
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Add your logic for Button 2 here
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Data fetched successfully, display it
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text("Name " + data[index]['name']),
                    Text("Email " + data[index]['email']),
                    Text("ID " + data[index]['pstu_id']),
                    Text("Registration " + data[index]['registration']),
                    Text("Blood Group " + data[index]['blood_group']),
                  ],
                );
              },
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
