import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/widgets/Menu_widget.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Locale _locale;
  String pdfasset = "";
  final prefs = new PreferenciasUsuario();

  PDFDocument _doc;
  bool _loading;

  @override
  void initState() {
    prefs.ultimaPagina = 'help';
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    await getLocale().then((locale) {
      this._locale = locale;
    });
    if (_locale.languageCode == "en") {
      pdfasset = "assets/help/en.pdf";
    } else {
      pdfasset = "assets/help/es.pdf";
    }
    print(_locale);
    print(pdfasset);
    try {
      final doc = await PDFDocument.fromAsset(pdfasset);
      setState(() {
        _doc = doc;
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(
          getTranlated(context, 'mHelp'),
        ),
        elevation: 0.0,
        backgroundColor: utils.cambiarColor(),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(utils.cambiarColor())),
            )
          : PDFViewer(
              document: _doc,
              indicatorBackground: utils.cambiarColor(),

              // showIndicator: false,
              showPicker: false,
            ),
      drawer: MenuWidget(),
    );
  }
}
