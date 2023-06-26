import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../screens/FilteredMarketPage.dart';
import '../screens/market.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedCity;
  String? selectedDistrict;
  String? selectedDay;

  List<String> cities = [];
  List<String> districts = [];
  List<String> days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'];

  List<Market> markets = []; // markets değişkeni tanımlandı

  @override
  void initState() {
    super.initState();
    fetchCities();
    fetchMarkets();
  }

  void applyFilters() {
    // Burada seçilen filtreleri kullanarak API'ye filtreleme isteği gönderebilirsiniz
    // Seçilen şehir: selectedCity
    // Seçilen ilçe: selectedDistrict
    // Seçilen gün: selectedDay

    // Örnek olarak, marketlerin listesini filtrelemek için aşağıdaki kodu kullanabilirsiniz:
    List<Market> filteredMarkets = [];
    for (Market market in markets) {
      if (selectedCity != null && market.il != selectedCity) {
        continue; // Şehir filtresine uymayanları atla
      }
      if (selectedDistrict != null && market.ilce != selectedDistrict) {
        continue; // İlçe filtresine uymayanları atla
      }
      if (selectedDay != null && market.gunler != selectedDay) {
        continue; // Gün filtresine uymayanları atla
      }
      filteredMarkets.add(market); // Filtrelere uyanları listeye ekle
    }

    // Filtrelenmiş marketleri kullanarak yeni bir sayfa oluşturabilirsiniz
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredMarketPage(markets: filteredMarkets),
      ),
    );
  }

  Future<void> fetchCities() async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:3000/api/pazar/iller')); // Replace with the actual API endpoint for cities
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        // Check if the data is a list
        setState(() {
          cities = List<String>.from(data);
        });
      } else {
        // Handle API response error
        print('Invalid response format for cities');
      }
    } else {
      // Handle API error
      print('Failed to fetch cities');
    }
  }

  Future<void> fetchDistricts(String city) async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:3000/api/pazar/ilceler/$city')); // Replace with the actual API endpoint for districts
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        // Check if the data is a list
        setState(() {
          districts = List<String>.from(data);
        });
      } else {
        // Handle API response error
        print('Invalid response format for districts');
      }
    } else {
      // Handle API error
      print('Failed to fetch districts');
    }
  }

  Future<void> fetchMarkets() async {
    final response =
        await http.get(Uri.parse('http://192.168.56.1:3000/api/pazar/pazars'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        markets = jsonResponse
            .map((market) => Market.fromJson(market))
            .toList(); // API'den gelen verileri markets listesine atama
      });
    } else {
      throw Exception('Failed to load markets from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtreler'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Şehir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue;
                    selectedDistrict = null;
                    districts = [];
                    fetchDistricts(newValue!);
                  });
                },
                items: cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'İlçe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedDistrict,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDistrict = newValue;
                  });
                },
                items: districts.map((String district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Gün',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue;
                  });
                },
                items: days.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: applyFilters,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text('Pazar Bul'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
