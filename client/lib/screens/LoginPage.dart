import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Eğer form validasyonu geçerse, giriş işlemi yapılır.
    if (_formKey.currentState!.validate()) {
      // Burada gerçek giriş işlemi yapılır.
      // Kullanıcı adı ve şifre ile bir API'ye istek yapılır.
      // İstek başarılı olursa, token alınır ve SharedPreferences'a kaydedilir.

      // Şimdilik sadece bir örnek token kaydedeceğiz.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'example_token');

      // Sonrasında kullanıcı ana sayfaya yönlendirilir.
      Navigator.pushReplacementNamed(context, '/home');
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
