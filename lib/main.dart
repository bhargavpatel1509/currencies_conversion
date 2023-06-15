import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final String baseCurrency = 'INR';
  List<String> currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'INR'
  ]; // Add more currencies as needed
  String selectedCurrency = 'INR';
  Map<String, dynamic> exchangeRates = {};

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    final url =
        'https://api.exchangerate-api.com/v4/latest/$baseCurrency'; // Replace with your Open Exchange Rates app ID
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRates = data['rates'].cast<String, dynamic>();
      });
    } else {
      print('Failed to fetch exchange rates: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          DropdownButton<String>(
            value: selectedCurrency,
            onChanged: (value) {
              setState(() {
                selectedCurrency = value!;
              });
            },
            items: currencies.map<DropdownMenuItem<String>>((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
          ),
          SizedBox(height: 20.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (BuildContext context, int index) {
              final currency = currencies[index];
              final rate = exchangeRates[currency];
              final convertedAmount = rate != null
                  ? (1 / rate) * exchangeRates[selectedCurrency]!
                  : 0.0;

              return ListTile(
                title: Text(currency),
                trailing: Text(convertedAmount.toStringAsFixed(2)),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          // exchangeRates[selectedCurrency]!
          // : 0.0;
        });
      }),
    );
  }
}
