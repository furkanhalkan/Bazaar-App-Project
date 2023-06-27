import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameSurnameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameSurnameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'http://192.168.56.1:3000/api/auth/register'), // your-api-url kısmını kendi Express API urliniz ile değiştirin.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': '', // Burayı uygulamanıza göre ayarlamalısınız
          'mail': _emailController.text,
          'password': _passwordController.text,
          'phone': _phoneController.text,
          'name_surname': _nameSurnameController.text,
        }),
      );

      if (response.statusCode == 201) {
        // If the server returns a 201 Created response,
        // then parse the JSON.
        // You can navigate the user to login page or directly log them in and navigate to home.
        Navigator.pushReplacementNamed(context, '/login'); // or '/home'
      } else {
        // If the server returns an error response,
        // then throw an exception.
        throw Exception('Failed to register');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen e-mail giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Parola',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen parola giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen telefon numarası giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameSurnameController,
                  decoration: InputDecoration(
                    labelText: 'Ad Soyad',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adınızı ve soyadınızı giriniz';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  child: Text('Kayıt Ol'),
                  onPressed: _register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
