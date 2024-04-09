import 'package:flutter/material.dart';
import 'ied.dart';
import 'confirm_dialog.dart';

class ListIED extends StatefulWidget {
  List<IED> listIEDs = [];

  ListIED({
    required this.listIEDs,
  });

  @override
  State<ListIED> createState() => _ListIEDState();
}

class _ListIEDState extends State<ListIED> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: widget.listIEDs.length,
        itemBuilder: (context, index) {
          final IED = widget.listIEDs[index];
          final item = IED.id;
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
            /*/// OUTRA FORMA DE FAZER \\\
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirmação"),
                    content:
                        const Text("Tem certeza que deseja excluir este item?"),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("DELETAR")),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCELAR"),
                      ),
                    ],
                  );
                },
              );
            },*/
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            //key: Key(item),
            key: UniqueKey(),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                widget.listIEDs.removeAt(index);
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
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.amber),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "IED: ${IED.id}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Text(
                    "Corrente (A) de Falta: ${IED.elementFault}",
                    style: const TextStyle(color: Colors.amber),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Corrente (A) de Pickup: ${IED.elementPickUp}",
                    style: const TextStyle(color: Colors.amber),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Tempo de Ajuste (s): ${IED.elementTimeDial}",
                    style: const TextStyle(color: Colors.amber),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Padrão (Característica): ${IED.pattern}",
                    style: const TextStyle(color: Colors.amber),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Tempo de Atuação (s): ${IED.operateTime.toStringAsFixed(3)}",
                    style: const TextStyle(color: Colors.amber),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Mensagem: ${IED.operationMessage}",
                    style: const TextStyle(color: Colors.amber),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //void setState(Null Function() param0) {}
}
