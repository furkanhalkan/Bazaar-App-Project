import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/market_detail_page.dart';
import '../screens/market.dart';

class MarketWidget extends StatelessWidget {
  Future<List<Market>> fetchMarkets() async {
    final response =
        await http.get(Uri.parse('http://192.168.56.1:3000/api/pazar/pazars'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((market) => new Market.fromJson(market)).toList();
    } else {
      throw Exception('Failed to load markets from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Market>>(
      future: fetchMarkets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Market> markets = snapshot.data!;
          return ListView(
            children: markets.map((Market market) {
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(market.pazar_adi),
                      subtitle: Text(market.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketDetailPage(market)),
                        );
                      },
                    ),
                    ButtonBar(
                      children: <Widget>[
                        TextButton(
                          child: Text(market.gunler),
                          onPressed: () {
                            /* Etiketlere tıklanınca yapılacaklar */
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
