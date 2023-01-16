import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class GenerateQrCode extends StatefulWidget {
  GenerateQrCode({Key? key}) : super(key: key);

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  TextEditingController nameController = TextEditingController();
  final _myFormKey = GlobalKey<FormState>();
  final qrKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  Future<Image>? image;
  String? text;

  // Future<void> _saveQr()async{
  //
  // }
  // Future<String> get imagePath async {
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   return '$directory/qr.png';
  // }
  //
  // Future<Image> _loadImage() async {
  //   return await imagePath.then((imagePath) => Image.asset(imagePath));
  // }
  //
  // Future<void> _captureAndSaveQRCode() async {
  //   final imageDirectory = await imagePath;
  //   screenshotController.captureAndSave(imageDirectory);
  //   setState(() {
  //     image = _loadImage();
  //   });
  // }

  @override
  void initState() {
    // image = _loadImage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Generate Qr Code'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
              key: _myFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null && value == "") {
                        return 'Please enter your name';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Full Name', hintText: 'Enter your name'),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          text = nameController.text == ""
                              ? null
                              : nameController.text;
                        });
                        await FirebaseFirestore.instance
                            .collection('Data')
                            .doc('1234546')
                            .set({
                          'text': text,
                          // 'qrcode': QrImage
                        });
                      },
                      child: Text("Generate Qr")),
                  SizedBox(
                    height: 20,
                  ),
                  (text == null)
                      ? Text('Please enter text to show here .....')
                      : Column(
                          children: [
                            // RepaintBoundary(
                            //   key: qrKey,
                            //   child:
                              Screenshot(
                                controller: screenshotController,
                                child: QrImage(
                                  data: text!,
                                  gapless: false,
                                  backgroundColor: Colors.white,
                                  version: QrVersions.auto,
                                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                                ),
                              ),
                            // ),
                            TextButton(
                                onPressed: () async {
                                   final screenshotImage = await screenshotController.capture();
                                   if(screenshotImage == null) return ;

                                   await saveImage(screenshotImage).whenComplete(() => Fluttertoast.showToast(msg: "Saved to gallery"));
                                  // _captureAndSaveQRCode();
                                  // var url = QrImage(data: text!,gapless: true,);
                                  // await GallerySaver.saveImage(url);
                                }, child: Text('Download'))
                          ],
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<String> saveImage(Uint8List bytes) async{
    await [Permission.storage].request();

    final name = "QrCode ${DateTime.now()}";
    final result = await ImageGallerySaver.saveImage(bytes,name: name);
    return result['filePath'];
    
  }

  Future<void> renderImage() async {
    //Get the render object from context.
    final RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //Convert to the image
    final ui.Image image = await boundary.toImage();
  }
  // void takeScreenShot() async {
  //   PermissionStatus res;
  //   res = await Permission.storage.request();
  //   if (res.isGranted) {
  //     final boundary =
  //     qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     // We can increse the size of QR using pixel ratio
  //     final image = await boundary.toImage(pixelRatio: 5.0);
  //     final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
  //     if (byteData != null) {
  //       final pngBytes = byteData.buffer.asUint8List();
  //       // getting directory of our phone
  //       final directory = (await getApplicationDocumentsDirectory()).path;
  //       final imgFile = File(
  //         '${directory}/${DateTime.now()}${qr}.png',
  //       );
  //       imgFile.writeAsBytes(pngBytes);
  //       GallerySaver.saveImage(imgFile.path).then((success) async {
  //         //In here you can show snackbar or do something in the backend at successfull download
  //       });
  //     }
  //   }
  // }

  void upload(String field) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('user');
    ref
        .doc('QrString')
        .set({'text': text.toString()}).whenComplete(() => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Upload completed'),
              );
            }));
  }
}
