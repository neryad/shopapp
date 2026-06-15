import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/models/product_model.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';

import 'package:share_plus/share_plus.dart';
import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:csv/csv.dart' as csv_pkg;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pocketlist/src/utils/file_save_helper.dart';
import 'package:uuid/uuid.dart';

class ImportExportPage extends StatefulWidget {
  ImportExportPage({Key? key}) : super(key: key);

  @override
  _ImportExportPageState createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  final uuid = Uuid();

  bool _isLoading = false;
  String? _errorMessage;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'importExportTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          // Botón de importar con tooltip
          Tooltip(
            message: getTranslated(context, 'importTooltip'),
            child: IconButton(
              onPressed: _isLoading ? null : pickFile,
              icon: Icon(Icons.file_download),
            ),
          ),
          // Botón de ayuda
          Tooltip(
            message: getTranslated(context, 'helpTooltip'),
            child: IconButton(
              onPressed: _showHelpDialog,
              icon: Icon(Icons.help_outline),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(getTranslated(context, 'processing')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Header con información
        FutureBuilder<List<Lista>>(
          future: DBProvider.db.getTodasLista(),
          builder: (context, snapshot) {
            final hasLists = snapshot.hasData && snapshot.data!.isNotEmpty;

            // Solo mostrar header si hay listas
            if (!hasLists) return SizedBox.shrink();

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Toca una lista para editarla o toca ↑ para exportarla',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Lista
        Expanded(child: _buildListView()),
      ],
    );
  }

  Widget _buildListView() {
    return FutureBuilder<List<Lista>>(
      future: DBProvider.db.getTodasLista(),
      builder: (context, AsyncSnapshot<List<Lista>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error al cargar las listas',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {}),
                  child: Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final lista = snapshot.data ?? [];

        if (lista.isEmpty) {
          return _buildEmptyState();
        }

        lista.sort((a, b) => b.fecha.compareTo(a.fecha));

        return ListView.separated(
          padding: EdgeInsets.all(12),
          itemCount: lista.length,
          separatorBuilder: (context, index) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildListCard(lista[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No hay listas guardadas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Crea una lista para poder exportarla',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, 'home'),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Crear lista',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: pickFile,
                icon: Icon(Icons.file_download),
                label: Text('Importar lista'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(Lista list) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingListPage(existingList: list),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Icono de lista
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              SizedBox(width: 12),

              // Información de la lista
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      list.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      list.superMaret.isEmpty
                          ? list.fecha
                          : '${list.superMaret} · ${list.fecha}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildInfoChip(
                          'Total: ${utils.numberFormat(list.total)}',
                          Colors.blue,
                        ),
                        _buildInfoChip(
                          'Presupuesto: ${utils.numberFormat(list.buget)}',
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Botón de exportar
              IconButton(
                icon: Icon(Icons.file_upload, size: 22, color: Colors.cyan[700]),
                tooltip: 'Exportar lista',
                onPressed: () => _generateCsv(context, list.id),
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _generateCsv(BuildContext context, String id) async {
    setState(() => _isLoading = true);

    try {
      List<Lista> lista = await DBProvider.db.getListIds(id);
      List<ProductModel> productModel = await DBProvider.db.getProdId(id);

      List<List<String>> csvData = [
        <String>[
          getTranslated(context, 'csvListName'),
          getTranslated(context, 'csvDate'),
          getTranslated(context, 'csvStore'),
          getTranslated(context, 'csvBudget'),
          getTranslated(context, 'csvTotal'),
          getTranslated(context, 'csvDifference')
        ],
        ...lista.map((e) => [
              e.title,
              e.fecha,
              e.superMaret,
              e.buget.toString(),
              e.total.toString(),
              e.diference.toString()
            ]),
        <String>[
          getTranslated(context, 'csvName'),
          getTranslated(context, 'csvPrice'),
          getTranslated(context, 'csvQuantity'),
          getTranslated(context, 'csvStatus')
        ],
        ...productModel.map((item) => [
              item.name,
              item.price.toString(),
              item.quantity.toString(),
              item.complete == 1
                  ? getTranslated(context, 'csvBought')
                  : getTranslated(context, 'csvNotBought')
            ]),
      ];

      String csvString = csv_pkg.CsvCodec().encode(csvData);

      if (kIsWeb) {
        final bytes = utf8.encode(csvString);
        await saveFile('${csvData[1][0]}.csv', Uint8List.fromList(bytes));
      } else {
        var fileName = csvData[1][0];
        Directory? dir = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory();
        String appDocPath = dir!.path;

        final File file =
            File(appDocPath + Platform.pathSeparator + fileName + '.csv');

        await file.writeAsString(csvString);
        await Share.shareXFiles([XFile(file.path)],
            text: getTranslated(context, 'csvFilePlaceholder'));
      }

      setState(() => _isLoading = false);
      _showSuccessSnack(
          getTranslated(context, 'csvExportSuccess'),
          getTranslated(context, 'strExport'));
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnack(
          '${getTranslated(context, 'csvExportError')}: ${e.toString()}',
          getTranslated(context, 'strExport'));
    }
  }

  Future<void> pickFile() async {
    setState(() => _isLoading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null) {
        if (kIsWeb) {
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            final csvString = utf8.decode(bytes);
            final fields = csv_pkg.CsvCodec().decode(csvString);
            await saveList(context, fields);
          }
        } else {
          File file = File(result.files.single.path!);
          final csvString = await file.readAsString();
          final fields = csv_pkg.CsvCodec().decode(csvString);
          await saveList(context, fields);
        }
        setState(() {});
      }
    } catch (e) {
      _showErrorSnack(
          '${getTranslated(context, 'csvImportError')}: ${e.toString()}',
          getTranslated(context, 'strImport'));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> saveList(
      BuildContext context, List<dynamic> importedList) async {
    try {
      if (importedList.length < 3) {
        _showErrorSnack('CSV inválido: muy pocas filas',
            getTranslated(context, 'strImport'));
        return;
      }
      if (importedList[1] is! List || (importedList[1] as List).length < 6) {
        _showErrorSnack('CSV inválido: datos de lista incompletos',
            getTranslated(context, 'strImport'));
        return;
      }

      String lisId = uuid.v4();
      final listaImportada = Lista(
        id: lisId,
        title: importedList[1][0]?.toString() ?? '',
        superMaret: importedList[1][2]?.toString() ?? '',
        fecha: importedList[1][1]?.toString() ?? '',
        total: double.tryParse(importedList[1][4].toString()) ?? 0.0,
        diference: double.tryParse(importedList[1][5].toString()) ?? 0.0,
        buget: double.tryParse(importedList[1][3].toString()) ?? 0.0,
      );

      await DBProvider.db.nuevoLista(listaImportada);

      for (var i = 2; i < importedList.length; i++) {
        final row = importedList[i];
        if (row is! List || row.length < 4) continue;

        final product = ProductModel(
          name: row[0]?.toString() ?? '',
          price: double.tryParse(row[1].toString()) ?? 0.0,
          quantity: int.tryParse(row[2].toString()) ?? 1,
          complete:
              (row[3]?.toString() == getTranslated(context, 'csvBought'))
                  ? 1
                  : 0,
          listId: listaImportada.id,
        );
        if (product.name.isNotEmpty) {
          await DBProvider.db.newProd(product);
        }
      }

      _showSuccessSnack(getTranslated(context, 'csvImportSuccess'),
          getTranslated(context, 'strImport'));
    } catch (e) {
      _showErrorSnack(
          '${getTranslated(context, 'csvImportError')}: ${e.toString()}',
          getTranslated(context, 'strImport'));
    }
  }

  void _showSuccessSnack(String msg, String title) {
    Flushbar(
      title: title,
      message: msg,
      icon: Icon(Icons.check_circle, size: 28, color: Colors.white),
      leftBarIndicatorColor: Colors.green,
      backgroundColor: Colors.green[700]!,
      duration: Duration(seconds: 3),
    ).show(context);
  }

  void _showErrorSnack(String msg, String title) {
    Flushbar(
      title: title,
      message: msg,
      icon: Icon(Icons.error, size: 28, color: Colors.white),
      leftBarIndicatorColor: Colors.red,
      backgroundColor: Colors.red[700]!,
      duration: Duration(seconds: 4),
    ).show(context);
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.help_outline,
                color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 12),
            Text('Cómo usar  ?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              Icons.file_upload,
              'Exportar',
              'Toca el ícono de descarga en cada lista para exportarla como archivo CSV.',
            ),
            SizedBox(height: 16),
            _buildHelpItem(
              Icons.file_download,
              'Importar',
              'Toca el ícono de subir en la parte superior para importar un archivo CSV.',
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, size: 20, color: Colors.amber[900]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Solo se pueden importar archivos CSV exportados desde PocketList',
                      style: TextStyle(fontSize: 12, color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon,
              color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
