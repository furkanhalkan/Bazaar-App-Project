import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../constants/project_color.dart';
import 'market.dart';
import 'market_detail_page.dart';

class FilteredMarketPage extends StatelessWidget {
  final List<Market> markets;

  const FilteredMarketPage({required this.markets});

  // Market günlerine göre rengi belirlemek için bir method
  Color getColorBasedOnMarketDay(String day) {
    Map<String, Color> dayColors = {
      'Pazartesi': Colors.blue,
      'Salı': Colors.green,
      'Çarşamba': Colors.yellow,
      'Perşembe': Colors.orange,
      'Cuma': Colors.red,
      'Cumartesi': Colors.purple,
      'Pazar': Colors.brown,
    };

    // Eğer map'te belirtilen bir gün yoksa varsayılan renk olarak siyahı kullan
    return dayColors[day] ?? Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filtrelenmiş Pazarlar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: markets.isNotEmpty
          ? ListView.builder(
              itemCount: markets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MarketDetailPage(market: markets[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: context.sized.dynamicHeight(0.25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ProjectColors.cartColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 6), // Shadow offset
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    color: ProjectColors.cartColor,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: ProjectColors.cartColor,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            markets[index].pazar_adi,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontSize: 16,
                                                ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            markets[index].description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: context.sized.dynamicWidth(0.4),
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: getColorBasedOnMarketDay(
                                          markets[index].gunler),
                                    ),
                                    child: Center(
                                      child: Text(
                                        markets[index].gunler,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: 16,
                                                color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CircleAvatar(
                            // CircleAvatar widget'ını sona ekliyoruz
                            child:
                                Icon(Icons.chevron_right, color: Colors.white),
                            backgroundColor: Colors.green,
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("Pazar Bulunamadı")),
    );
  }
}
