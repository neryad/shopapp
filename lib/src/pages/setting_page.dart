import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
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

    _selectedRadio( int valor)  {
    
        prefs.genero = valor;
        _genero = valor;
      setState(() {
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
            child: Text('Personalización temas', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
          ),

          Divider(),
          RadioListTile(title:Text('Naraja'),
          value: 1, 
          groupValue: _genero, 
          onChanged: _selectedRadio,
          ),
          RadioListTile(
            title:Text('Azul'),
            value: 2, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
              RadioListTile(
            title:Text('Verde'),
            value: 3, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
              RadioListTile(
            title:Text('Rosado'),
            value: 4, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
             RadioListTile(
            title:Text('Gris'),
            value: 5, 
            groupValue: _genero, 
            onChanged: _selectedRadio,
            ),
          Divider(),
           Container(
            padding: EdgeInsets.all(5.0),
            child: Text('Personalización usuario', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
          ),
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