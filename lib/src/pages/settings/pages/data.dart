import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:another_flushbar/flushbar.dart';

class DataPage extends StatefulWidget {
  DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool _isLoading = false;
  int _totalLists = 0;
  int _totalProducts = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final lists = await DBProvider.db.getToadasLista();
    final products = await DBProvider.db.getAllProducts();

    setState(() {
      _totalLists = lists.length;
      _totalProducts = products.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(getTranlated(context, 'dataTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                          Icons.storage,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestión de Datos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Administra tu información',
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

            // Estadísticas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de Datos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.list_alt,
                          title: 'Listas',
                          value: _totalLists.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.shopping_cart,
                          title: 'Productos',
                          value: _totalProducts.toString(),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Acciones de datos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Limpiar listas completadas
                  _buildActionCard(
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.orange,
                    title: 'Limpiar listas completadas',
                    subtitle: 'Elimina solo las listas que ya completaste',
                    onTap: _deleteCompletedLists,
                  ),

                  SizedBox(height: 12),

                  // Eliminar productos temporales
                  _buildActionCard(
                    icon: Icons.delete_sweep,
                    iconColor: Colors.purple,
                    title: 'Limpiar productos temporales',
                    subtitle: 'Elimina artículos de lista en progreso',
                    onTap: _deleteTempProducts,
                  ),

                  SizedBox(height: 12),

                  // Eliminar todo
                  _buildActionCard(
                    icon: Icons.delete_forever,
                    iconColor: Colors.red,
                    title: getTranlated(context, 'deleteAllList'),
                    subtitle: getTranlated(context, 'deletePar'),
                    onTap: () => _validateEliminar(context),
                    isDanger: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Información de almacenamiento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
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
                                'Datos Locales',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Todos tus datos se almacenan localmente en tu dispositivo. Eliminar datos no se puede deshacer.',
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
                ],
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDanger
            ? Border.all(color: Colors.red.withOpacity(0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDanger ? Colors.red : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteCompletedLists() async {
    final lists = await DBProvider.db.getToadasLista();
    final completedLists = lists.where((list) {
      // Aquí puedes agregar lógica para determinar si una lista está completa
      // Por ahora, considera que una lista está completa si tiene todos sus productos marcados
      return false; // Implementar lógica según tu modelo
    }).toList();

    if (completedLists.isEmpty) {
      _showInfoSnack('No hay listas completadas para eliminar');
      return;
    }

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
          '¿Deseas eliminar ${completedLists.length} lista(s) completada(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Eliminar listas completadas
              for (var list in completedLists) {
                await DBProvider.db.deleteList(list.id);
              }
              await _loadStatistics();
              Navigator.pop(context);
              _showSuccessSnack(
                  '${completedLists.length} lista(s) eliminada(s)');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTempProducts() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.purple),
            SizedBox(width: 12),
            Text('Confirmar'),
          ],
        ),
        content: Text(
          '¿Deseas eliminar todos los productos temporales?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DBProvider.db.deleteAllTempProd('tmp');
              await _loadStatistics();
              Navigator.pop(context);
              _showSuccessSnack('Productos temporales eliminados');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> limpiarTodo() async {
    setState(() => _isLoading = true);

    try {
      await DBProvider.db.deleteAllList();
      await DBProvider.db.deleteAllProd();
      await _loadStatistics();

      setState(() => _isLoading = false);
      Navigator.of(context).pop();

      _showSuccessSnack(getTranlated(context, 'dataDelete'));
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnack('Error al eliminar los datos');
    }
  }

  _validateEliminar(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  getTranlated(context, 'deleteAllList'),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getTranlated(context, 'deleteDialo')),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta acción no se puede deshacer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                getTranlated(context, 'leave'),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () => limpiarTodo(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                getTranlated(context, 'accept'),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnack(String msg) {
    Flushbar(
      message: msg,
      icon: Icon(Icons.check_circle, size: 28, color: Colors.white),
      leftBarIndicatorColor: Colors.green,
      backgroundColor: Colors.green[700]!,
      duration: Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
    ).show(context);
  }

  void _showErrorSnack(String msg) {
    Flushbar(
      message: msg,
      icon: Icon(Icons.error, size: 28, color: Colors.white),
      leftBarIndicatorColor: Colors.red,
      backgroundColor: Colors.red[700]!,
      duration: Duration(seconds: 3),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
    ).show(context);
  }

  void _showInfoSnack(String msg) {
    Flushbar(
      message: msg,
      icon: Icon(Icons.info_outline,
          size: 28, color: Theme.of(context).colorScheme.primary),
      leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
      duration: Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
    ).show(context);
  }
}
