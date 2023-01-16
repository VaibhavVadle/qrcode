
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({Key? key}) : super(key: key);

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {

  String? qrCodeResult;
  String? qrCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                qrCodeResult == null || qrCodeResult == ""
                    ? "Please scan qr code to show data :"
                    : "Data: " + qrCodeResult!,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _scan();
                }, child: Text('Scan'))
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async{
    ScanResult result = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: -1
      )
    );
    setState(() {
      qrCodeResult = result.rawContent;
      qrCode = result.toString();
      print(qrCode);
    });
  }
}
