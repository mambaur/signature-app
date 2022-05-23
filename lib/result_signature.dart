import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ResultSignature extends StatefulWidget {
  final Uint8List? image;
  const ResultSignature({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  State<ResultSignature> createState() => _ResultSignatureState();
}

class _ResultSignatureState extends State<ResultSignature> {
  String? imagePath;
  File? image;

  Future saveToGalery() async {
    Random random = Random();
    int randomNumber = random.nextInt(10000);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    if (await Permission.storage.request().isGranted) {
      File file = File('$tempPath/signature-$randomNumber.png');
      await file.writeAsBytes(widget.image!);
      image = file;
      setState(() {});
      print(image!.path);
      await ImageGallerySaver.saveFile(image!.path);
      Fluttertoast.showToast(msg: 'Signature successfully saved to galery!');
    }
  }

  Future shareImage() async {
    await Share.shareFiles([image!.path], text: 'Here is my signature!');
  }

  @override
  void initState() {
    saveToGalery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result',
            style: GoogleFonts.pacifico(color: Colors.black, fontSize: 23)),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: image != null
                  ? Container(
                      padding: EdgeInsets.all(15),
                      // child: Image.file(image!),
                      child: Image.file(image!),
                    )
                  : Container(),
            ),
          ),
          GestureDetector(
            onTap: () {
              shareImage();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ' Share Signature',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
