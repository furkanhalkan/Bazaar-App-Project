import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Profile {
  final String name;
  final String email;
  final String phone;

  Profile({required this.name, required this.email, required this.phone});
}

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Profile? profile;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? user_id = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse('http://192.168.56.1:3000/api/profil/profile/$user_id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      setState(() {
        profile = Profile(
          name: user['name_surname'],
          email: user['mail'],
          phone: user['phone'],
        );
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Ad Soyad: ${profile?.name ?? ''}'),
        ),
        ListTile(
          title: Text('E-Mail: ${profile?.email ?? ''}'),
        ),
        ListTile(
          title: Text('Telefon: ${profile?.phone ?? ''}'),
        ),
        ListTile(
          title: ElevatedButton(
            child: Text('Çıkış Yap'),
            onPressed: logout,
          ),
        ),
      ],
    );
  }
}
