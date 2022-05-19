import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:signature/signature.dart';
import 'package:simple_signature/result_signature.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderValue = 1;
  Color penColor = Colors.black;
  double strokeWith = 3.0;

  SignatureController? _controller;

  @override
  void initState() {
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
      exportPenColor: Colors.black,
    );

    super.initState();
    _controller!.addListener(() => print('Value changed'));
  }

  changeSignature() {
    _controller = SignatureController(
      penStrokeWidth: strokeWith,
      penColor: penColor,
      exportBackgroundColor: Colors.transparent,
      exportPenColor: penColor,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Signature', style: GoogleFonts.pacifico(color: Colors.black)),
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                _chooseColorsDialog();
              },
              icon: Icon(
                Icons.palette,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                _updateBrushDialog();
              },
              icon: Icon(
                Icons.brush,
                color: Colors.black,
              )),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Signature(
              controller: _controller!,
              height: double.infinity,
              backgroundColor: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.save),
                  color: Colors.white,
                  onPressed: () async {
                    if (_controller!.isNotEmpty) {
                      // final Uint8List? data = await _controller!.toPngBytes();
                      final Uint8List? data = await _controller!.toPngBytes();
                      if (data != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return ResultSignature(
                            image: data,
                          );
                        }));
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.white,
                  onPressed: () {
                    // changeColor();
                    setState(() => _controller!.undo());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.white,
                  onPressed: () {
                    setState(() => _controller!.redo());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.white,
                  onPressed: () {
                    setState(() => _controller!.clear());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseColorsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    penColor = Colors.black;
                    changeSignature();
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                  ),
                  title: Text('Black'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    penColor = Colors.red;
                    changeSignature();
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                  title: Text('Red'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    penColor = Colors.green;
                    changeSignature();
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                  title: Text('Green'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    penColor = Colors.blue;
                    changeSignature();
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                  ),
                  title: Text('Blue'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    penColor = Colors.yellow;
                    changeSignature();
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.yellow, shape: BoxShape.circle),
                  ),
                  title: Text('Yelllow'),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    penColor = Colors.brown;
                    changeSignature();
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.brown, shape: BoxShape.circle),
                  ),
                  title: Text('Brown'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateBrushDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                            color: penColor, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.grey,
                          inactiveColor: Colors.black.withOpacity(0.2),
                          value: _currentSliderValue,
                          max: 20,
                          divisions: 10,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                              strokeWith = _currentSliderValue.toDouble();
                              changeSignature();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            color: penColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
