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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // This is new
          child: profile == null
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70,
                      child: ClipOval(
                        child: Icon(
                          Icons.account_circle,
                          size: 120,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Profil Bilgileri',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 60),
                    Card(
                      child: ListTile(
                        title: Text('Ad Soyad: ${profile?.name ?? ''}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('E-Mail: ${profile?.email ?? ''}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Telefon: ${profile?.phone ?? ''}'),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: logout,
                      child: Text(
                        'Çıkış Yap',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
