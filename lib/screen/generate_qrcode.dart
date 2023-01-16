import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCode extends StatefulWidget {
  GenerateQrCode({Key? key}) : super(key: key);

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  TextEditingController nameController = TextEditingController();
  final _myFormKey = GlobalKey<FormState>();

  String? text;

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
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: nameController,
                    validator: (value){
                      if( value==null && value == ""){
                        return 'Please enter your name';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your name'),
                  ),
                  SizedBox(height: 30
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          text = nameController.text == ""
                              ? null
                              : nameController.text;
                        });
                        await FirebaseFirestore.instance.collection('Data').doc('1234546').set({
                          'text': text,
                          // 'qrcode': QrImage
                        });
                      },
                      child: Text("Generate Qr")),

                  SizedBox(height: 20,),
                  (text == null)
                      ? Text('Please enter text to show here .....')
                      : QrImage(
                    data: text!,
                    gapless: true,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  void upload(String field) async{
    CollectionReference ref = FirebaseFirestore.instance.collection('user');
    ref.doc('QrString')
        .set({
      'text': text.toString()
    }).whenComplete(() => showDialog(context: context, builder:(context){
      return AlertDialog(
        title: Text('Upload completed'),
      );
    }));
  }
}
