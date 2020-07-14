import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';
 
class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool _colorsecundario;
  int _genero;
  String _nombre;
  TextEditingController _textEditingController;
  final prefs = new PreferenciasUsuario();

@override
  void initState()  {
    _genero = prefs.genero;
    _colorsecundario = prefs.colorSecundario;
    super.initState();
    //cargarPrefs();
    // (prefs.colorSecundario) ? Colors.teal : Colors.blue
    _textEditingController = new TextEditingController( text: prefs.nombreUsuario);
  }

    _SelectedRadio( int valor)  {
        //_genero = valor;
        prefs.genero = valor;
        _genero = valor;
      setState(() {
       // utils.cambiarColor();
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Ajustes"),
        backgroundColor: utils.cambiarColor(),
        
      ),
      drawer: MenuWidget(),
      body: ListView(
        children:<Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Text('Configuracion', style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),),
          ),

          Divider(),
          SwitchListTile(
            title: Text('asd'),
            value: _colorsecundario, 
            onChanged: (value) {
              
              setState(() {
                _colorsecundario = value;
                prefs.colorSecundario = value;
              });
            }
          ),

          RadioListTile(title:Text('Naraja'),
          value: 1, 
          groupValue: _genero, 
          onChanged: _SelectedRadio,
          ),
          RadioListTile(
            title:Text('Azul'),
            value: 2, 
            groupValue: _genero, 
            onChanged: _SelectedRadio,
            ),
              RadioListTile(
            title:Text('Verde'),
            value: 3, 
            groupValue: _genero, 
            onChanged: _SelectedRadio,
            ),
              RadioListTile(
            title:Text('Rosado'),
            value: 4, 
            groupValue: _genero, 
            onChanged: _SelectedRadio,
            ),
             RadioListTile(
            title:Text('Gris'),
            value: 5, 
            groupValue: _genero, 
            onChanged: _SelectedRadio,
            ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal:20.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Nombre usuario',
                helperText: 'Nombre del usuario'
              ),
              onChanged: (value) { 
                prefs.nombreUsuario = value;
              },
            )
          )
        ]
      ),
     
    );
  }
}