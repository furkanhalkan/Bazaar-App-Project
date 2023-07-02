import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'http://192.168.56.1:3000/api/auth/login'), // your-api-url kısmını kendi Express API urliniz ile değiştirin.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mail': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON and store the token.
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonResponse['token']);
        await prefs.setString('user_id', jsonResponse['user_id']);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // If the server returns an error response,
        // then throw an exception.
        throw Exception('Failed to login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Kullanıcı adı alanı
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Mail Adresi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen Mail Adresi Giriniz';
                  }
                  return null;
                },
              ),
              // Şifre alanı
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen Şifre Giriniz';
                  }
                  return null;
                },
              ),
              // Giriş düğmesi
              ElevatedButton(
                onPressed: _login,
                child: Text('Giriş Yap'),
              ),
              ElevatedButton(
                child: Text('Kayıt Ol'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
