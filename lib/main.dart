import 'dart:ffi';

import 'package:flutter/material.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds(lbs)',
    'ounces',
  ];

  final Map<String, int> _measureMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds(lbs)': 6,
    'ounces': 7,
  };

  final dynamic _conversionFormulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  late String _startMeasure;
  late String _convertedMeasure;
  double _numberFrom = 0;
  String _resultMessage = "";

  @override
  void initState() {
    _startMeasure = _measures.first;
    _convertedMeasure = _measures.first;
    _numberFrom = 0;
    super.initState();
  }

  final TextStyle inputTextStyle =
      TextStyle(fontSize: 20, color: Colors.blue[900]);

  final TextStyle lableStyle = TextStyle(fontSize: 24, color: Colors.grey[700]);

  void _convert(double value, String from, String to) {
    int? nFrom = _measureMap[from];
    int? nTo = _measureMap[to];
    var multiplier = _conversionFormulas[nFrom.toString()][nTo];
    var result = value * multiplier;
    if (result == 0) {
      _resultMessage = "This conversion can not be performed";
    } else {
      _resultMessage =
          "${_numberFrom.toString()} $from is ${result.toString()} $to";
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Unit converter'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Spacer(),
              Text(
                'Value',
                style: lableStyle,
              ),
              Spacer(),
              TextField(
                style: inputTextStyle,
                decoration: const InputDecoration(
                    hintText: "Please insert the measure to be converted"),
                onChanged: (value) {
                  double? input = double.tryParse(value);
                  if (input != null) {
                    setState(() {
                      _numberFrom = input;
                    });
                  }
                },
              ),
              Spacer(),
              Text(
                'From',
                style: lableStyle,
              ),
              DropdownButton(
                  isExpanded: true,
                  style: inputTextStyle,
                  value: _startMeasure,
                  items: _measures
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _startMeasure = v as String;
                    });
                  }),
              const Spacer(),
              Text(
                "To",
                style: lableStyle,
              ),
              Spacer(),
              DropdownButton(
                  isExpanded: true,
                  style: inputTextStyle,
                  value: _convertedMeasure,
                  items: _measures
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _convertedMeasure = v as String;
                    });
                  }),
              const Spacer(
                flex: 2,
              ),
              ElevatedButton(
                onPressed: () {
                  _convert(_numberFrom, _startMeasure, _convertedMeasure);
                },
                child: Text("Convert"),
              ),
              const Spacer(
                flex: 2,
              ),
              Text(
                _resultMessage,
                style: lableStyle,
              ),
              Spacer(
                flex: 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
