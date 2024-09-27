import 'package:flutter/material.dart';

void main() => runApp(TempConversionApp());

class TempConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temperature Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TempConverter(),
    );
  }
}

class TempConverter extends StatefulWidget {
  @override
  _TempConverterState createState() => _TempConverterState();
}

class _TempConverterState extends State<TempConverter> {
  int _selectedConversionIndex = 0; // 0 = F to C, 1 = C to F
  final _tempController = TextEditingController();
  String _result = '';
  List<String> _history = [];
  bool _isExpanded = false; // State to track whether the history is expanded

  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double _fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  void _convertTemperature() {
    double inputTemp = double.tryParse(_tempController.text) ?? 0.0;
    double outputTemp;

    if (_selectedConversionIndex == 0) {
      outputTemp = _fahrenheitToCelsius(inputTemp);
      _result = '$inputTemp°F = ${outputTemp.toStringAsFixed(2)}°C';
    } else {
      outputTemp = _celsiusToFahrenheit(inputTemp);
      _result = '$inputTemp°C = ${outputTemp.toStringAsFixed(2)}°F';
    }

    setState(() {
      _history.add(_result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Temperature Converter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Conversion',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ToggleButtons(
                isSelected: [
                  _selectedConversionIndex == 0,
                  _selectedConversionIndex == 1
                ],
                onPressed: (int index) {
                  setState(() {
                    _selectedConversionIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                selectedColor: Colors.black54,
                fillColor: Colors.white,
                color: Colors.grey,
                constraints: BoxConstraints(minWidth: 188, minHeight: 50),
                children: const <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'F to C',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'C to F',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Temperature',
                labelStyle: TextStyle(fontSize: 22),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                suffixIcon: Icon(Icons.thermostat_outlined),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _convertTemperature,
                    child: Text(
                      'Convert',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tempController.clear();
                        _result = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                _result,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),

            // Expanded history part with arrow for collapsing/expanding
            ExpansionTile(
              title: const Text(
                'History',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              children: [
                if (_history.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _history[index],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                if (_history.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No conversion history yet.',
                      style:
                      TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
