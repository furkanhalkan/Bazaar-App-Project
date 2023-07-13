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
          'yorum_yapan_kisi': useradd!,
          'yorum': commentController.text,
        }),
      );

      if (response.statusCode == 201) {
        commentController.text = '';
        _getComments();
      } else {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.market.pazar_adi,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.market.pazar_adi,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.market.description,
                    style: TextStyle(fontSize: 18, color: Colors.green[800]),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Pazar Kuruluş Günü: ${widget.market.gunler}',
                    style: TextStyle(fontSize: 18, color: Colors.green[800]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            Container(
              height: 300,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(widget.market.latitude),
                          double.parse(widget.market.longitude)),
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: _markers,
                  ),
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green[600],
                      child: Icon(Icons.location_pin),
                      onPressed: () {
                        // Zoom in to the location
                        _mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(double.parse(widget.market.latitude),
                                double.parse(widget.market.longitude)),
                            16.0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              'Yorumlar',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600]),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      comments[index]['user']['name_surname'][0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green[600],
                  ),
                  title: Text(
                    comments[index]['user']['name_surname'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(comments[index]['yorum']),
                );
              },
            ),
            SizedBox(height: 16.0),
            if (isLoggedIn)
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: 'Yorum yaz',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _postComment,
                      icon: Icon(Icons.send),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
