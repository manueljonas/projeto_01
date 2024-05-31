import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/form_ied.dart';
import '../model/ied.dart';
import '../model/list_ied.dart';
import '../pages/page_confirm_dialog.dart';
import '../pages/page_login.dart';
import '../utils/app_routes.dart';

class IEDGrid extends StatefulWidget {
  List<IED> listIEDs = [];
  final bool showOnlyFavorites;

  IEDGrid({
    super.key,
    required this.listIEDs,
    required this.showOnlyFavorites,
  });

  @override
  State<IEDGrid> createState() => _IEDGridState();
}

class _IEDGridState extends State<IEDGrid> {
  @override
  Widget build(BuildContext context) {
    //final _formKey = GlobalKey<FormState>();
    final formData = <String, Object>{};

/*    final provider = Provider.of<IEDList>(context);
    final List<IED> listIEDs =
        widget.showOnlyFavorites ? provider.favoriteItems : provider.items;*/

    //PEGANDO CONTEUDO PELO PROVIDER
    //
    final providerIEDList = Provider.of<IEDList>(
      context,
      //listen: false,
    );

    void submitForm(IED ied) {
/*    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
*/
      //final arg = ModalRoute.of(context)?.settings.arguments;
      //final ied = arg as IED;
      formData['id'] = ied.id;
      formData['substationName'] = ied.substationName;
      formData['iedName'] = ied.iedName;
      formData['elementFault'] = ied.elementFault;
      formData['elementPickUp'] = ied.elementPickUp;
      formData['elementTimeDial'] = ied.elementTimeDial;
      formData['pattern'] = ied.pattern;
      formData['operateTime'] = ied.operateTime;
      formData['operationMessage'] = ied.operationMessage;
      formData['isFavorite'] = ied.isFavorite;
      formData['isArchived'] = ied.isArchived;

      Provider.of<IEDList>(
        context,
        listen: false,
      ).saveIED(formData).then((value) {
/*        print('id = ${ied.id}');
        print('substationName = ${ied.substationName}');
        print('iedName = ${ied.iedName}');
        print('elementFault = ${ied.elementFault}');
        print('elementPickUp = ${ied.elementPickUp}');
        print('elementTimeDial = ${ied.elementTimeDial}');
        print('pattern = ${ied.pattern}');
        print('operateTime = ${ied.operateTime}');
        print('operationMessage = ${ied.operationMessage}');
        print('isFavorite = ${ied.isFavorite}');
        print('isArchived = ${ied.isArchived}'); */
      });
    }

    void updatePage() {
      setState(() {});
    }

    void updateIED(
      String id,
      String substationName,
      String iedName,
      double elementFault,
      double elementPickUp,
      double elementTimeDial,
      String pattern,
      double operateTime,
      String operationMessage,
      bool isFavorite,
      bool isArchived,
    ) {
      IED ied = IED(
        id: id,
        substationName: substationName,
        iedName: iedName,
        elementFault: elementFault,
        elementPickUp: elementPickUp,
        elementTimeDial: elementTimeDial,
        pattern: pattern,
        operateTime: operateTime,
        operationMessage: operationMessage,
        isFavorite: isFavorite,
        isArchived: isArchived,
      );

      try {
        for (var i = 0; i < widget.listIEDs.length; i++) {
          //print('Element index: $i');
          if (widget.listIEDs[i].substationName == ied.substationName &&
              widget.listIEDs[i].iedName == ied.iedName) {
            setState(() {
              widget.listIEDs[i].elementFault = ied.elementFault;
              widget.listIEDs[i].elementPickUp = ied.elementPickUp;
              widget.listIEDs[i].elementTimeDial = ied.elementTimeDial;
              widget.listIEDs[i].pattern = ied.pattern;
              widget.listIEDs[i].operateTime = ied.operateTime;
              widget.listIEDs[i].operationMessage = ied.operationMessage;
              if (widget.listIEDs[i].isArchived) {
                submitForm(widget.listIEDs[i]);
              }
            });
          } else {
            print('Elemento não encontrado na lista!');
          }
        }
      } on Exception catch (e) {
        print(e);
      }
      Navigator.of(context).pop();
    }

    //Modal
    void openTaskFormModal(BuildContext context) {
      showModalBottomSheet(
          context: context,
          builder: (_) {
            return FormIED(updateIED);
          });
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: widget.listIEDs.length,
        itemBuilder: (context, index) {
          final ied = widget.listIEDs[index];
          final item = ied.iedName;
          return Dismissible(
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (context) => ConfirmDialog(
                  title: 'Excluir IED',
                  content: 'Tem certeza que deseja excluir este IED?',
                  onConfirm: () {
                    Navigator.of(context).pop(true);
                  },
                  onCancel: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              );
            },
            key: UniqueKey(),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                widget.listIEDs.removeAt(index);
                //providerIEDList.removeIED(ied);
              });
              // Then show a snackbar.
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$item excluido!')));
            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.red),
            /*child: ListTile(
              title: Text(item),
            ),*/
            child: Card(
              color: Colors.black,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.amber),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "SE: ${ied.substationName}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              "IED: ${ied.iedName}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Corrente (A) de Falta: ${ied.elementFault}",
                        style: const TextStyle(color: Colors.amber),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Corrente (A) de Pickup: ${ied.elementPickUp}",
                        style: const TextStyle(color: Colors.amber),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Tempo de Ajuste (s): ${ied.elementTimeDial}",
                        style: const TextStyle(color: Colors.amber),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Padrão (Característica): ${ied.pattern}",
                        style: const TextStyle(color: Colors.amber),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Tempo de Atuação (s): ${ied.operateTime.toStringAsFixed(3)}",
                        style: const TextStyle(color: Colors.amber),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Mensagem: ${ied.operationMessage}",
                        style: const TextStyle(color: Colors.amber),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Favoritar",
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          //Adicionando metodo ao clique do botão
                          ied.toggleFavorite();
                          if (ied.isArchived) {
                            submitForm(ied);
                          } else {
                            updatePage();
                          }
                        },
                        //Pegando icone se estiver favorito ou não
                        /*icon: Consumer<IED>(
                          builder: (context, ied, child) => Icon(ied.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                        ),*/
                        icon: Icon(ied.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: Colors.red,
                      ),
                      const Text(
                        "Editar",
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () => (LoginPage().user == null)
                            ? {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.LOGIN_PAGE,
                                )
                              }
                            : openTaskFormModal(context),
                        icon: const Icon(Icons.edit),
                        color: Colors.red,
                      ),
                      const Text(
                        "Arquivar",
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          //Adicionando metodo ao clique do botão
                          ied.toggleArchive();
                          //if (ied.isArchived) {
                          submitForm(ied);
                          //} else {
                          //providerIEDList.removeIED(ied);
                          widget.listIEDs.removeAt(index);
                          updatePage();
                          //}
                        },
                        //Pegando icone se estiver arquivado ou não
                        /*icon: Consumer<IED>(
                          builder: (context, ied, child) => Icon(ied.isArchived
                              ? Icons.archive
                              : Icons.archive_outlined),
                        ),*/
                        icon: Icon(ied.isArchived
                            ? Icons.archive
                            : Icons.archive_outlined),
                        color: Colors.red,
                      ),
                    ],
                  ),
                  //const Align(alignment: Alignment.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
