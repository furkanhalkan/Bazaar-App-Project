import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../constants/project_color.dart';
import 'market.dart';
import 'market_detail_page.dart';

class FilteredMarketPage extends StatelessWidget {
  final List<Market> markets;

  const FilteredMarketPage({required this.markets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtrelenmiş Pazarlar'),
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
                      height: context.dynamicHeight(0.25),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              width: context.dynamicWidth(0.4),
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  markets[index].gunler,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
