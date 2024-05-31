import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

class QRreader extends StatefulWidget {
  const QRreader({super.key});

  @override
  State<QRreader> createState() => _QRreaderState();
}

class _QRreaderState extends State<QRreader> {
  String? barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaner de QR y codigo de barras'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  allowDuplicates: false,
                  onDetect: (barcode, args) {
                    setState(() {
                      this.barcode = barcode.rawValue;
                    });
                    Vibration.vibrate();
                    _showDataModal(barcode.rawValue!);
                  },
                ),
                Center(
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: CornerPainter(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: (barcode != null)
                    ? Text(
                        '$barcode',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        'Scan a code',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDataModal(String data) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado'),
          content: Text(data),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(0, 20);
    path.lineTo(0, 0);
    path.lineTo(20, 0);

    path.moveTo(size.width - 20, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 20);

    path.moveTo(0, size.height - 20);
    path.lineTo(0, size.height);
    path.lineTo(20, size.height);

    path.moveTo(size.width - 20, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
