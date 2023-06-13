import 'package:flutter/material.dart';
import '../screens/market.dart';

class MarketWidget extends StatelessWidget {
  final List<Market> markets = [
    Market('Başlık 1', 'Açıklama 1', 'Etiket 1'),
    Market('Başlık 2', 'Açıklama 2', 'Etiket 2'),
    // Diğer pazarlar...
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: markets.map((Market market) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(market.title),
                subtitle: Text(market.description),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: Text(market.tag),
                    onPressed: () {/* Etiketlere tıklanınca yapılacaklar */},
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
