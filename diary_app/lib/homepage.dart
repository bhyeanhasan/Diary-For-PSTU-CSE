import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'manage_profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Uri.parse('https://appcse16.pythonanywhere.com/profile/'),
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
              child: const Text(
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
            return Container(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  // return Column(
                  //   children: [
                  //     Text("Name " + data[index]['name']),
                  //     Text("Email " + data[index]['email']),
                  //     Text("ID " + data[index]['pstu_id']),
                  //     Text("Registration " + data[index]['registration']),
                  //     Text("Blood Group " + data[index]['blood_group']),
                  //   ],
                  // );

                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: 350,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16),
                              Text(
                                data[index]['name'],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("ID: " + data[index]['pstu_id']),
                                  SizedBox(width: 8),
                                  Text("REG: " + data[index]['registration']),
                                ],
                              ),
                              // Text(
                              //   data[index]['pstu_id'],
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  SizedBox(width: 8),
                                  Text(data[index]['address']),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail_outline),
                                  SizedBox(width: 8),
                                  Text(data[index]['email']),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call),
                                  SizedBox(width: 8),
                                  Text(data[index]['twitter']),
                                  TextButton(
                                      onPressed: () {
                                        launch(
                                            "tel://" + data[index]['twitter']);
                                      },
                                      child: Text('Call now')),
                                ],
                              ),

                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.facebook),
                                  SizedBox(width: 8),
                                  TextButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse('https://www.facebook.com/'+data[index]['facebook']);
                                        if (!await launchUrl(url)) {
                                        throw Exception('Could not launch');
                                        }
                                      },
                                      child: Text("Facebook")),
                                  SizedBox(width: 20),
                                  Icon(Icons.supervised_user_circle_rounded),
                                  SizedBox(width: 8),
                                  TextButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse('https://www.linkedin.com/in/'+data[index]['linkedin']);
                                        if (!await launchUrl(url)) {
                                          throw Exception('Could not launch');
                                        }
                                      },
                                      child: Text("LinkedIn")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
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
