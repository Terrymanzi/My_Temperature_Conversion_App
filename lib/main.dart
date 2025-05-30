import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Temperature Converter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final TextEditingController _temperatureController = TextEditingController();
  String _conversionType = 'FtoC'; // Default to Fahrenheit to Celsius
  double? _result;
  final List<String> _history = [];

  void _convertTemperature() {
    final String inputText = _temperatureController.text.trim();

    if (inputText.isEmpty) {
      _showErrorDialog('Please enter a temperature value');
      return;
    }

    final double? inputTemp = double.tryParse(inputText);
    if (inputTemp == null) {
      _showErrorDialog('Please enter a valid number');
      return;
    }

    double convertedTemp;
    String historyEntry;

    if (_conversionType == 'FtoC') {
      // °C = (°F - 32) × 5/9
      convertedTemp = (inputTemp - 32) * 5 / 9;
      historyEntry =
          'F to C: ${inputTemp.toStringAsFixed(1)} => ${convertedTemp.toStringAsFixed(2)}';
    } else {
      // °F = °C × 9/5 + 32
      convertedTemp = inputTemp * 9 / 5 + 32;
      historyEntry =
          'C to F: ${inputTemp.toStringAsFixed(1)} => ${convertedTemp.toStringAsFixed(2)}';
    }

    setState(() {
      _result = convertedTemp;
      _history.insert(0, historyEntry); // Add to beginning of list
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout();
          } else {
            return _buildLandscapeLayout();
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildConverterSection(),
          const SizedBox(height: 20),
          _buildResultSection(),
          const SizedBox(height: 20),
          Expanded(child: _buildHistorySection()),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildConverterSection(),
                const SizedBox(height: 20),
                _buildResultSection(),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(flex: 1, child: _buildHistorySection()),
        ],
      ),
    );
  }

  Widget _buildConverterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'User Temperature Input',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _temperatureController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            // labelText: 'Enter Temp',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Conversion Type:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('F to C'),
                value: 'FtoC',
                groupValue: _conversionType,
                onChanged: (String? value) {
                  setState(() {
                    _conversionType = value!;
                    _result = null;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('C to F'),
                value: 'CtoF',
                groupValue: _conversionType,
                onChanged: (String? value) {
                  setState(() {
                    _conversionType = value!;
                    _result = null;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _convertTemperature,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Convert'),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Result',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Text(
            _result != null
                ? '${_result!.toStringAsFixed(2)}°${_conversionType == 'FtoC' ? 'C' : 'F'}'
                : 'No conversion yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _result != null ? Colors.blue : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_history.isNotEmpty)
              TextButton(onPressed: _clearHistory, child: const Text('Clear')),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child:
                _history.isEmpty
                    ? const Center(
                      child: Text(
                        'No conversions yet',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Text(
                            _history[index],
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }
}
