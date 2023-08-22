import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'register.dart';
import 'dart:convert';
import 'splash_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      const String apiUrl = 'https://appcse16.pythonanywhere.com/auth/';

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final storage = FlutterSecureStorage();
        final tokenMap = json.decode(response.body);
        final token = tokenMap['token'];
        await storage.write(key: 'auth_token', value: token);
        // final token = await storage.read(key: 'auth_token');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        print(response.statusCode);
      }

      print(response);
    }
  }

  void _logout() async {
    const String apiUrl = 'https://appcse16.pythonanywhere.com/auth/';

    final response = await http.get(
      Uri.parse(apiUrl),
    );

    print(response);

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 16.0,),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Login'),
              ),

              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
