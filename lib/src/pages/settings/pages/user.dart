import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../../../../main.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final prefs = PreferenciasUsuario();
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: prefs.nombreUsuario);
    _nameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasChanges = _nameController.text != prefs.nombreUsuario;
    });
  }

  String _getInitials() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '?';

    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      prefs.nombreUsuario = _nameController.text.trim();

      setState(() {
        _hasChanges = false;
      });

      MyApp.stateSet(context);

      _showSuccessSnack(
        getTranlated(context, 'changeComplete') ?? 'Cambios guardados',
      );
    }
  }

  void _clearProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text('Confirmar'),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas borrar tu información de perfil?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _nameController.clear();
              prefs.nombreUsuario = '';

              setState(() {
                _hasChanges = false;
              });

              Navigator.pop(context);
              MyApp.stateSet(context);

              _showInfoSnack('Perfil borrado correctamente');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Borrar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(getTranlated(context, 'userTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          if (_hasChanges)
            IconButton(
              icon: Icon(Icons.check),
              tooltip: 'Guardar cambios',
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header con avatar
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Hero(
                      tag: 'user_avatar',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _nameController.text.isEmpty
                          ? getTranlated(context, 'guestUser') ?? 'Usuario'
                          : _nameController.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Información del perfil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranlated(context, 'userNameConf') ??
                          'Información del Perfil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Campo de nombre
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: getTranlated(context, 'userInpText') ??
                              'Nombre completo',
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          helperText:
                              'Ingresa tu nombre para personalizar la app',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          if (value.trim().length < 2) {
                            return 'El nombre debe tener al menos 2 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // Botón de guardar
                    if (_hasChanges)
                      Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Guardar Cambios',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),

                    SizedBox(height: 32),

                    // Sección de acciones
                    Text(
                      'Acciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Botón de borrar perfil
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          'Borrar información del perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Elimina tu nombre del perfil',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.red,
                        ),
                        onTap: _clearProfile,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Información adicional
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tu información está segura',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tu información se guarda localmente en tu dispositivo y no se comparte con terceros.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnack(String msg) {
    Flushbar(
      message: msg,
      icon: Icon(
        Icons.check_circle,
        size: 28,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.green,
      backgroundColor: Colors.green[700]!,
      duration: Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
    ).show(context);
  }

  void _showInfoSnack(String msg) {
    Flushbar(
      message: msg,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Theme.of(context).colorScheme.primary,
      ),
      leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
      duration: Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
    ).show(context);
  }
}
