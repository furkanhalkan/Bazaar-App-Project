import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'market.dart';

class MarketDetailPage extends StatefulWidget {
  final Market market;

  MarketDetailPage(this.market);

  @override
  _MarketDetailPageState createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  late GoogleMapController _mapController;

  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(41.38879, 33.78227),
    zoom: 14.0,
  );

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
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _mapController = controller;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
