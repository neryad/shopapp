import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/main.dart';

class ColorPage extends StatefulWidget {
  ColorPage({Key? key}) : super(key: key);

  @override
  _ColorPageState createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  final prefs = PreferenciasUsuario();

  // Colores predefinidos
  static const List<ColorOption> predefinedColors = [
    ColorOption(color: Color(0xFFFF6F5E), name: 'Coral'),
    ColorOption(color: Color(0xFF0E5C68), name: 'Azul Océano'),
    ColorOption(color: Color(0xFF2B7600), name: 'Verde Bosque'),
    ColorOption(color: Color(0xFFFF1493), name: 'Rosa Fucsia'),
    ColorOption(color: Color(0xFF424242), name: 'Gris Oscuro'),
    ColorOption(color: Color(0xFF7E57C2), name: 'Morado'),
    ColorOption(color: Color(0xFFE53935), name: 'Rojo Intenso'),
    ColorOption(color: Color(0xFF00897B), name: 'Verde Agua'),
    ColorOption(color: Color(0xFFFF6F00), name: 'Naranja'),
    ColorOption(color: Color(0xFF5E35B1), name: 'Índigo'),
    ColorOption(color: Color(0xFFC62828), name: 'Rojo Vino'),
    ColorOption(color: Color(0xFF00695C), name: 'Teal'),
  ];

  Color get currentColor {
    if (prefs.color == 0) {
      // Color personalizado
      return Color(prefs.customColorValue);
    }
    final index = prefs.color - 1;
    if (index >= 0 && index < predefinedColors.length) {
      return predefinedColors[index].color;
    }
    return predefinedColors[0].color;
  }

  void _selectColor(Color color) {
    // Buscar si el color está en predefinidos
    final index = predefinedColors.indexWhere((c) => c.color == color);
    if (index != -1) {
      prefs.color = index + 1;
    } else {
      // Color personalizado
      prefs.customColorValue = color.value;
      prefs.color = 0;
    }
    setState(() {});
    MyApp.stateSet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(getTranlated(context, 'themTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header decorativo
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.palette,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personalización',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Elige tu color favorito',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Vista previa del color actual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Color Actual',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          _getColorName(currentColor),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Colores predefinidos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Colores Predefinidos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: predefinedColors.length,
                    itemBuilder: (context, index) {
                      final colorOption = predefinedColors[index];
                      final isSelected =
                          currentColor.value == colorOption.color.value;

                      return GestureDetector(
                        onTap: () => _selectColor(colorOption.color),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorOption.color,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorOption.color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              colorOption.name,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Color personalizado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Color Personalizado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      title: const Text('Selecciona un color'),
                      subtitle: Text(
                        '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () => _showColorPicker(context),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Información
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: currentColor.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: currentColor,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personalización Automática',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: currentColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'El color seleccionado se aplicará en toda la aplicación automáticamente.',
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
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getColorName(Color color) {
    final match = predefinedColors.firstWhere(
      (c) => c.color.value == color.value,
      orElse: () => ColorOption(color: color, name: 'Personalizado'),
    );
    return match.name;
  }

  void _showColorPicker(BuildContext context) {
    Color selectedColor = currentColor;

    showDialog(
      context: context,
      builder: (context) {
        final hexController = TextEditingController(
          text:
              selectedColor.value.toRadixString(16).substring(2).toUpperCase(),
        );

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.colorize, color: selectedColor),
                  SizedBox(width: 12),
                  Text('Selecciona un Color'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Vista previa del color
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.palette,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Input de código HEX
                    TextField(
                      controller: hexController,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Código HEX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixText: '#',
                        counterText: '',
                        helperText: 'Ejemplo: FF6F5E',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9A-Fa-f]')),
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: (value) {
                        if (value.length == 6) {
                          try {
                            setState(() {
                              selectedColor = Color(
                                int.parse(value, radix: 16) + 0xFF000000,
                              );
                            });
                          } catch (e) {
                            // Valor inválido
                          }
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    // Colores rápidos
                    Text(
                      'Colores Rápidos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Colors.red,
                        Colors.pink,
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.indigo,
                        Colors.blue,
                        Colors.cyan,
                        Colors.teal,
                        Colors.green,
                        Colors.lightGreen,
                        Colors.orange,
                        Colors.deepOrange,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                              hexController.text = color.value
                                  .toRadixString(16)
                                  .substring(2)
                                  .toUpperCase();
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedColor.value == color.value
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    hexController.dispose();
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectColor(selectedColor);
                    hexController.dispose();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Aplicar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Clase helper para colores con nombre
class ColorOption {
  final Color color;
  final String name;

  const ColorOption({required this.color, required this.name});
}
