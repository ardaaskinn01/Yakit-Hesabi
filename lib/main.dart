import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yakıt Hesaplayıcı',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const FuelCalculator(),
    );
  }
}

class FuelCalculator extends StatefulWidget {
  const FuelCalculator({super.key});

  @override
  _FuelCalculatorState createState() => _FuelCalculatorState();
}

class _FuelCalculatorState extends State<FuelCalculator> {
  final TextEditingController _controller = TextEditingController();
  double? result;
  int? selectedPercentage;

  void calculateFuel(int percentage) {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen litre miktarını giriniz!')),
      );
      return;
    }

    double liters = double.tryParse(_controller.text) ?? 0;
    double calculatedLiters = liters - (liters * percentage / 100);

    setState(() {
      result = calculatedLiters;
      selectedPercentage = percentage;
    });

    // E10 ve E85 için özel mesajlar
    if (percentage == 10) {
      showCoolMessage('Çocuk musun, daha fazla ethanol koy! 🚀', Colors.orange);
    } else if (percentage == 85) {
      showCoolMessage('Yavaş laaan, uçak mı uçuruyorsun! 🛩️', Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF006400), Color(0xFF7CFC00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Yakıt Hesaplayıcı',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Litre miktarı girin',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        16,
                            (index) {
                          int eValue = 5 * (index + 2);
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              elevation: 3,
                            ),
                            onPressed: () => calculateFuel(eValue),
                            child: Text(
                              'E$eValue',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (result != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sonuçlar',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(thickness: 1, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          'Girilen Miktar: ${_controller.text} litre',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                        Text(
                          'Seçilen Oran: E$selectedPercentage\n',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                        Text(
                          'Ek Etanol Miktarı ${(double.parse(_controller.text) * ((selectedPercentage! - 5) / 100)).toStringAsFixed(2)} litre',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showCoolMessage(String message, Color color) {
    final overlay = Overlay.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    // 0.55 oranı: ekranın %55'inde baloncuk çıkar
    final fixedTop = screenHeight * 0.55;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: fixedTop,
        left: 30,
        right: 30,
        child: CoolBubble(message: message, color: color),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

}

class CoolBubble extends StatefulWidget {
  final String message;
  final Color color;

  const CoolBubble({Key? key, required this.message, required this.color}) : super(key: key);

  @override
  State<CoolBubble> createState() => _CoolBubbleState();
}

class _CoolBubbleState extends State<CoolBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
