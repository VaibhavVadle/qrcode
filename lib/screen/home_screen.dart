import 'package:flutter/material.dart';
import 'package:qrcode/screen/generate_qrcode.dart';
import 'package:qrcode/screen/scan_qrcode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateQrCode()));
                },
                child: Text('Generate QrCode')),
            SizedBox(
              height:30
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQrCode()));
                },
                child: Text('Scan QrCode')),
          ],
        ),
      )
    );
  }
}
