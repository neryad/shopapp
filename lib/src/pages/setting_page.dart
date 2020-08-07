import 'package:flutter/material.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/data/class/language.dart';
import 'package:shopapp/src/localization/localization_constant.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';

 
class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  int _genero;
  TextEditingController _textEditingController;

  final prefs = new PreferenciasUsuario();

@override
  void initState()  {
    _genero = prefs.genero;
    super.initState();
    _textEditingController = new TextEditingController( text: prefs.nombreUsuario);
  }
    void _changeLanguea(Language language) async {
      Locale _temp = await setLocal(language.languageCode);
      MyApp.setLocale(context, _temp);
    }
    _selectedRadio( int valor)  {
    
        prefs.genero = valor;
        _genero = valor;
      setState(() {
      });
    }
  @override
  Widget build(BuildContext context) {
   // var appLanguage = Provider.of< mmg.AppLanguage>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title:Text(getTranlated(context, 'settTitle')),
        backgroundColor: utils.cambiarColor(),
        
      ),
      drawer: MenuWidget(),
      body: ListView(
        children:<Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Text(getTranlated(context, 'themTitle'), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
          ),

          Divider(),
          RadioListTile(title:Text(getTranlated(context, 'nColor'),style: TextStyle(fontSize: 20),),
          value: 1, 
          groupValue: _genero, 
          onChanged: _selectedRadio,
          ),
          RadioListTile(
            title:Text(getTranlated(context, 'bColor'),style: TextStyle(fontSize: 20),),
            value: 2, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
              RadioListTile(
            title:Text(getTranlated(context, 'geColor'),style: TextStyle(fontSize: 20),),
            value: 3, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
              RadioListTile(
            title:Text(getTranlated(context, 'pColor'),style: TextStyle(fontSize: 20),),
            value: 4, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
             RadioListTile(
            title:Text(getTranlated(context, 'gyColor'),style: TextStyle(fontSize: 20),),
            value: 5, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
          Divider(),
           Container(
            padding: EdgeInsets.all(5.0),
            child: Text(getTranlated(context, 'userTitle'), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal:20.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: getTranlated(context, 'userInpText'),
               // helperText: getTranlated(context, 'userInpText')
                
              ),
              onChanged: (value) { 
                prefs.nombreUsuario = value;
              },
            )
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              items: Language.languageList()
              .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(value: lang,child: Row(children: [Text(lang.name)],))).toList(), 
              onChanged: (Language language ){
                _changeLanguea(language);
              }
              ),
          ),
          // RaisedButton(
          //         onPressed: () {
          //           Language language;
          //           language.languageCode = "es";
          //          // appLanguage.changeLanguage(Locale("es"));
          //          _changeLanguea(language);
          //         },
          //         child: Text('Mensaje'),
          //       )
        ]
      ),
     
    );
  }
}