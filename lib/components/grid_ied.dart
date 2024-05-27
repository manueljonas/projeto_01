import 'package:flutter/material.dart';
import '../components/grid_ied_archive.dart';
import 'package:provider/provider.dart';

import '../model/ied.dart';
import '../model/list_ied.dart';
import '../pages/page_confirm_dialog.dart';

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
    final providerIED = Provider.of<IED>(
      context,
      //listen: false,
    );

    final providerIEDList = Provider.of<IEDList>(
      context,
      //listen: false,
    );

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      if (formData.isEmpty) {
        final arg = ModalRoute.of(context)?.settings.arguments;

        if (arg != null) {
          final ied = arg as IED;
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

          print('id = ${ied.id}');
          print('substationName = ${ied.substationName}');
          print('iedName = ${ied.iedName}');
          print('substationName = ${ied.substationName}');
          print('elementFault = ${ied.elementFault}');
          print('elementPickUp = ${ied.elementPickUp}');
          print('pattern = ${ied.pattern}');
          print('operateTime = ${ied.operateTime}');
          print('operationMessage = ${ied.operationMessage}');
          print('isFavorite = ${ied.isFavorite}');
          print('isArchived = ${ied.isArchived}');
        }
      }
    }

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

      print('id = ${ied.id}');
      print('substationName = ${ied.substationName}');
      print('iedName = ${ied.iedName}');
      print('substationName = ${ied.substationName}');
      print('elementFault = ${ied.elementFault}');
      print('elementPickUp = ${ied.elementPickUp}');
      print('pattern = ${ied.pattern}');
      print('operateTime = ${ied.operateTime}');
      print('operationMessage = ${ied.operationMessage}');
      print('isFavorite = ${ied.isFavorite}');
      print('isArchived = ${ied.isArchived}');
      Provider.of<IEDList>(
        context,
        listen: false,
      ).saveIED(formData).then((value) {
        //ied.id = providerIED.id;
        //providerIEDList.saveIED(formData);
        //providerIEDList.addIED(ied);
        //providerIEDList.updateIEDList(ied);
        //providerIEDList.updateIEDInFirebase(ied);
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
                providerIEDList.removeIEDInFirebase(ied);
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
                        "Arquivar",
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          //Adicionando metodo ao clique do botão
                          ied.toggleArchive();
                          submitForm(ied);
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
                      const Text(
                        "Editar",
                        style: TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          //Adicionando metodo ao clique do botão
                          //ied.toggleArchive();
                          submitForm(ied);
                        },
                        icon: const Icon(Icons.edit),
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
