import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

enum StatusAd { initial, loaded }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderValue = 5;
  Color penColor = Colors.black;
  double strokeWith = 3.0;
  StrokeCap strokeCap = StrokeCap.round;

  BannerAd? myBanner;

  StatusAd statusAd = StatusAd.initial;

  BannerAdListener listener() => BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          if (kDebugMode) {
            print('Ad Loaded.');
          }
          setState(() {
            statusAd = StatusAd.loaded;
          });
        },
      );

  SignatureView? _signatureView;

  @override
  void initState() {
    myBanner = BannerAd(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-2465007971338713/1087521621',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener(),
    );
    myBanner!.load();

    refreshCanvas();

    super.initState();
  }

  void refreshCanvas() {
    _signatureView = SignatureView(
      backgroundColor: Colors.transparent,
      penStyle: Paint()
        ..color = penColor
        ..strokeCap = strokeCap
        ..strokeWidth = _currentSliderValue,
      onSigned: (data) {
        if (kDebugMode) print("On change $data");
      },
    );
  }

  @override
  void dispose() {
    myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature',
            style: GoogleFonts.pacifico(color: Colors.black, fontSize: 23)),
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                _updateBrushDialog();
              },
              icon: const Icon(
                Icons.brush,
                color: Colors.black,
              )),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          statusAd == StatusAd.loaded
              ? Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  alignment: Alignment.center,
                  width: myBanner!.size.width.toDouble(),
                  height: myBanner!.size.height.toDouble(),
                  child: AdWidget(ad: myBanner!),
                )
              : Container(),
          Expanded(
            child: Container(
              child: _signatureView,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(vertical: 5),
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
                    if (_signatureView!.isEmpty) {
                      Fluttertoast.showToast(msg: 'Your signature is empty');
                      return;
                    }
                    Uint8List? data = await _signatureView!.exportBytes();
                    // ignore: use_build_context_synchronously
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return ResultSignature(
                        image: data,
                      );
                    }));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.draw),
                  color: Colors.white,
                  onPressed: () async {
                    _strokeCapDialog();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.palette),
                  color: Colors.white,
                  onPressed: () {
                    _chooseColorsDialog();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.white,
                  onPressed: () async {
                    _signatureView!.clear();
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
                Container(
                  color: penColor == Colors.black ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      penColor = Colors.black;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                    ),
                    title: const Text('Black'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: penColor == Colors.red ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      penColor = Colors.red;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                    title: const Text('Red'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: penColor == Colors.green ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      penColor = Colors.green;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                    title: const Text('Green'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: penColor == Colors.blue ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      penColor = Colors.blue;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                    ),
                    title: const Text('Blue'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color:
                      penColor == Colors.yellow ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      penColor = Colors.yellow;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.yellow, shape: BoxShape.circle),
                    ),
                    title: const Text('Yelllow'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: penColor == Colors.brown ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      penColor = Colors.brown;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.brown, shape: BoxShape.circle),
                    ),
                    title: const Text('Brown'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _strokeCapDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  color: strokeCap == StrokeCap.round
                      ? Colors.grey.shade100
                      : null,
                  child: ListTile(
                    onTap: () {
                      strokeCap = StrokeCap.round;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: const Text('Round'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color:
                      strokeCap == StrokeCap.butt ? Colors.grey.shade100 : null,
                  child: ListTile(
                    onTap: () {
                      strokeCap = StrokeCap.butt;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: const Text('Butt'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: strokeCap == StrokeCap.square
                      ? Colors.grey.shade100
                      : null,
                  child: ListTile(
                    onTap: () {
                      strokeCap = StrokeCap.square;
                      refreshCanvas();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: const Text('Square'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
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
                          activeColor: Colors.grey.shade200,
                          inactiveColor: Colors.black.withOpacity(0.1),
                          value: _currentSliderValue,
                          min: 1,
                          max: 20,
                          divisions: 10,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {});
                            this.setState(() {
                              _currentSliderValue = value;
                              strokeWith = _currentSliderValue.toDouble();
                              refreshCanvas();
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
