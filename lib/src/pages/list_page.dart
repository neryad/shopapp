import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';
import 'package:pocketlist/src/utils/pdf.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/models/List_model.dart';

import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pocketlist/src/utils/export_helper.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final prefs = PreferenciasUsuario();
  final lisForm = GlobalKey<FormState>();
  Lista listaModel = Lista();
  List<Lista> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    prefs.ultimaPagina = 'home';
    _loadLists();
  }

  Future<void> _loadLists() async {
    final data = await DBProvider.db.getTodasLista();
    if (mounted) {
      setState(() {
        _lists = data;
        _lists.sort((a, b) => b.fecha.compareTo(a.fecha));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_lists.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                getTranslated(context, 'noList'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                getTranslated(context, 'noList2'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLists,
      child: ListView.builder(
          key: ValueKey(_lists.map((l) => l.id).toList()),
          padding: const EdgeInsets.only(top: 8, bottom: 84),
          itemCount: _lists.length,
        itemBuilder: (context, i) {
          return Dismissible(
            direction: DismissDirection.endToStart,
            background: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            key: ValueKey(_lists[i].id),
            confirmDismiss: (direction) async {
              final confirmed = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  title: Text(getTranslated(context, 'delete')),
                  content: Text(getTranslated(context, 'deleteListDia')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(getTranslated(context, 'leave')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(getTranslated(context, 'accept')),
                    ),
                  ],
                ),
              );
              return confirmed ?? false;
            },
            onDismissed: (direction) {
              final deletedId = _lists[i].id;
              setState(() {
                _lists.removeAt(i);
              });
              DBProvider.db.deleteLista(deletedId).catchError((e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la lista')),
                  );
                }
                return 0;
              });
              utils.showSnack(
                  context, getTranslated(context, 'deletedList'));
            },
            child: card(_lists[i]),
          );
        }),
    );
  }

  Widget card(Lista lista) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ShoppingListPage(existingList: lista),
            ),
          );
          setState(() {}); // ← Fuerza reconstruir el FutureBuilder al volver
        },
        // onTap: () {
        //   var route = MaterialPageRoute(
        //       builder: (BuildContext context) =>
        //           ShoppingListPage(existingList: lista));
        //   Navigator.of(context).push(route);
        // },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lista.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (lista.superMaret.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.storefront_outlined,
                                    size: 16, color: colorScheme.secondary),
                                const SizedBox(width: 4),
                                Text(
                                  lista.superMaret,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${utils.numberFormat(lista.total)}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lista.fecha,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.share_outlined, size: 20,
                            color: colorScheme.primary),
                        onPressed: () => _showExportOptions(context, lista),
                        tooltip: 'Share',
                        padding: EdgeInsets.all(8),
                        constraints: BoxConstraints(),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 20,
                            color: colorScheme.secondary),
                        onPressed: () {
                          listaModel = lista;
                          _editarLista(context, lista);
                        },
                        tooltip: 'Edit',
                        padding: EdgeInsets.all(8),
                        constraints: BoxConstraints(),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20,
                            color: colorScheme.error),
                        onPressed: () => _validateEliminar(context, lista.id),
                        tooltip: 'Delete',
                        padding: EdgeInsets.all(8),
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateEliminar(BuildContext context, String id) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'delete')),
            content: new Text(getTranslated(context, 'deleteListDia')),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranslated(context, 'leave'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
              TextButton(
                  onPressed: () async {
                    await DBProvider.db.deleteLista(id);
                    Navigator.of(context).pop();
                    await _loadLists();
                    utils.showSnack(
                        context, getTranslated(context, 'deletedList'));
                  },
                  child: Text(
                    getTranslated(context, 'accept'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
            ],
          );
        });
  }

  Widget _nombrelista() {
    //weo
    return TextFormField(
      initialValue: listaModel.title,
      maxLength: 25,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => listaModel.title = value ?? '',
      decoration: InputDecoration(
        labelText: getTranslated(context, 'listName'),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _nombresupermeacdo() {
    return TextFormField(
      initialValue: listaModel.superMaret,
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => listaModel.superMaret = value ?? '',
      decoration: InputDecoration(
        labelText: getTranslated(context, 'shopName'),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  void _editarLista(BuildContext context, Lista lista) {
    listaModel = lista;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranslated(context, 'saveList')),
            content: Form(
              key: lisForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_nombrelista(), _nombresupermeacdo()],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranslated(context, 'leave'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
              TextButton(
                  onPressed: () async {
                    await saveList(lista);
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                        context, 'home'); // si navegas a home igual se refresca
                  },
                  child: Text(
                    getTranslated(context, 'save'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
            ],
          );
        });
  }

  saveList(Lista lista) async {
    lisForm.currentState!.save();
    try {
      await DBProvider.db.updateList(lista);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la lista')),
        );
      }
    }
  }

  void _showExportOptions(BuildContext context, Lista lista) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslated(context, 'exportOptions')),
          content: Text(getTranslated(context, 'chooseExportFormat')),
          actions: <Widget>[
            TextButton(
              child: Text("PDF"),
              onPressed: () async {
                Navigator.of(context).pop();
                final pdf = await ApiPdf.generateTAble(lista.id);
                if (!kIsWeb && pdf != null) {
                  await Share.shareXFiles([XFile(pdf.path)]);
                }
              },
            ),
            TextButton(
              child: Text("CSV"),
              onPressed: () {
                Navigator.of(context).pop();
                ExportHelper.generateCsv(context, lista.id);
              },
            ),
            TextButton(
              child: Text(getTranslated(context, 'cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
