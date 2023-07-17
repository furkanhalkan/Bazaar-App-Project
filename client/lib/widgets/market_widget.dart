import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pazar_rotasi/constants/project_color.dart';
import '../screens/market_detail_page.dart';
import '../screens/market.dart';

import 'package:kartal/kartal.dart';

class MarketWidget extends StatelessWidget {
  Future<List<Market>> fetchMarkets() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['API_URL']}/api/pazar/pazars'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((market) => new Market.fromJson(market)).toList();
    } else {
      throw Exception('Failed to load markets from API');
    }
  }

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
    return FutureBuilder<List<Market>>(
      future: fetchMarkets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Market> markets = snapshot.data!;
          return ListView(
            children: markets.map((Market market) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarketDetailPage(market: market),
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
                      // Row widget'ını düzenliyoruz
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Başlangıç ve son elemanlar arasında maksimum boşluk
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
                                          market.pazar_adi,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          market.description,
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
                                    color:
                                        getColorBasedOnMarketDay(market.gunler),
                                  ),
                                  child: Center(
                                    child: Text(
                                      market.gunler,
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
                          child: Icon(Icons.chevron_right, color: Colors.white),
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(
                            width:
                                8), // Icon ve sağ kenar arasında boşluk ekliyoruz
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
