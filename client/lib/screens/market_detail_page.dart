import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'market.dart';

class MarketDetailPage extends StatefulWidget {
  final Market market;

  MarketDetailPage({required this.market});

  @override
  _MarketDetailPageState createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  List comments = [];
  final commentController = TextEditingController();

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId('marketLocation'),
        position: LatLng(double.parse(widget.market.latitude),
            double.parse(widget.market.longitude)),
      ),
    );
    _getLoginStatus();
    _getComments();
  }

  void _getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Eğer kullanıcı giriş yapmamışsa, Giriş sayfasına yönlendir
      isLoggedIn = true;
    }
  }

  Future<void> _getComments() async {
    var response = await http.get(Uri.parse(
        'http://192.168.56.1:3000/api/pazar/yorumlar/${widget.market.id}'));
    if (response.statusCode == 200) {
      setState(() {
        comments = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> _postComment() async {
    if (isLoggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      String? useradd = prefs.getString('user_id');

      var response = await http.post(
        Uri.parse('http://192.168.56.1:3000/api/pazar/yorumlar/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'pazar_id': widget.market.id,
          'yorum_yapan_kisi': useradd!, // Add current user name here
          'yorum': commentController.text,
        }),
      );

      if (response.statusCode == 201) {
        commentController.text = '';
        _getComments();
      } else {
        print(
            'Server responded with status code ${response.statusCode} and body ${response.body}');
        throw Exception(
            'Server responded with status code ${response.statusCode} and body ${response.body}');
      }
    } else {
      // Show a message that the user needs to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.market.pazar_adi),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.market.pazar_adi,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.market.description,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16.0),
          Text(
            'Pazar Kuruluş Günü: ${widget.market.gunler}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 32.0),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(widget.market.latitude),
                    double.parse(widget.market.longitude)),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              markers: _markers,
            ),
          ),
          SizedBox(height: 32.0),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(comments[index]['user']['name_surname']),
                  subtitle: Text(comments[index]['yorum']),
                );
              },
            ),
          ),
          if (isLoggedIn)
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Yorum yaz',
                suffixIcon: IconButton(
                  onPressed: _postComment,
                  icon: Icon(Icons.send),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
