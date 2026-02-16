import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/utils/pdf.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/pages/details_page.dart';
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
  final prefs = new PreferenciasUsuario();
  final lisForm = GlobalKey<FormState>();
  Lista listaModel = new Lista();
  @override
  void initState() {
    super.initState();
    prefs.ultimaPagina = 'home';
  }

  @override
  Widget build(BuildContext context) {
    return _listContainer(context);
  }

  Widget _listContainer(BuildContext context) {
    return FutureBuilder<List<Lista>>(
      future: DBProvider.db.getToadasLista(),
      builder: (context, AsyncSnapshot<List<Lista>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lista = snapshot.data;

        if (lista == null || lista.isEmpty) {
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
                    getTranlated(context, 'noList'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getTranlated(context, 'noList2'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }
        lista.sort((a, b) => b.fecha.compareTo(a.fecha));
        return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 84),
            itemCount: lista.length,
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
                key: Key(lista[i].id),
                onDismissed: (direction) {
                  utils.showSnack(
                      context, getTranlated(context, 'deletedList'));
                  DBProvider.db.deleteLista(lista[i].id);
                  lista.removeAt(i);
                  setState(() {});
                },
                child: card(lista[i]),
              );
            });
      },
    );
  }

  Widget card(Lista lista) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          var route = MaterialPageRoute(
              builder: (BuildContext context) => DetailsPage(savelist: lista));
          Navigator.of(context).push(route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
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
                        icon: Icon(Icons.share_outlined,
                            color: colorScheme.primary),
                        onPressed: () => _showExportOptions(context, lista),
                        tooltip: 'Share',
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined,
                            color: colorScheme.secondary),
                        onPressed: () {
                          listaModel = lista;
                          _editarLista(context, lista);
                        },
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: colorScheme.error),
                        onPressed: () => _validateEliminar(context, lista.id),
                        tooltip: 'Delete',
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
            title: Text(getTranlated(context, 'delete')),
            content: new Text(getTranlated(context, 'deleteListDia')),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    DBProvider.db.deleteLista(id);
                    Navigator.of(context).pop();
                    utils.showSnack(
                        context, getTranlated(context, 'deletedList'));
                    setState(() {});
                  },
                  child: Text(
                    getTranlated(context, 'accept'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
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
        labelText: getTranlated(context, 'listName'),
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
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
        // counterText: '',
        labelText: getTranlated(context, 'shopName'),
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
        // hintText: 'Nombre localidad',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
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
            title: Text(getTranlated(context, 'saveList')),
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
                    getTranlated(context, 'leave'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    saveList(lista);
                    Navigator.pushNamed(context, 'home');
                  },
                  child: Text(
                    getTranlated(context, 'save'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
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
      print(e);
    }
  }

  void _showExportOptions(BuildContext context, Lista lista) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranlated(context, 'exportOptions')),
          content: Text(getTranlated(context, 'chooseExportFormat')),
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
              child: Text(getTranlated(context, 'cancel')),
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
