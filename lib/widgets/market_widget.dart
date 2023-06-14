import 'package:flutter/material.dart';
import '../screens/market_detail_page.dart';
import '../screens/market.dart';

class MarketWidget extends StatelessWidget {
  final List<Market> markets = [
    Market('1', 'Başlık 1', 'Açıklama 1', 'Etiket 1', 'Resim 1'),
    Market('2', 'Başlık 2', 'Açıklama 2', 'Etiket 2', 'Resim 2'),
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
