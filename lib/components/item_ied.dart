import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/form_ied.dart';
import '../model/ied.dart';
import '../model/list_ied.dart';
import '../utils/app_routes.dart';

class IEDItem extends StatefulWidget {
  List<IED> listIEDs = [];

  IEDItem({
    Key? key,
    required this.listIEDs,
  }) : super(key: key);

  @override
  State<IEDItem> createState() => _IEDItemState();
}

class _IEDItemState extends State<IEDItem> {
  final Map<String, Image> _imagens = {
    "relay": Image.asset(
      "images/relay.png",
      fit: BoxFit.cover,
    ),
  };

  @override
  Widget build(BuildContext context) {
    //PEGANDO CONTEUDO PELO PROVIDER
    final ied = Provider.of<IED>(
      context,
      //listen: false,
    );

    final iedsList = Provider.of<IEDList>(
      context,
      //listen: false,
    );

    //final ied = context.watch<IED>();
    var isFavorite = context.select<IED, bool>((ied) => ied.isFavorite);
    Image imagemRelay = _imagens["relay"]!;
    final formData = <String, Object>{};

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

/*      Provider.of<IEDList>(
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
    }*/

      Provider.of<IEDList>(
        context,
        listen: false,
      ).updateIEDInFirebase(ied);
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

    return ClipRRect(
      //corta de forma arredondada o elemento de acordo com o BorderRaius
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: GridTileBar(
          backgroundColor: Colors.black87,
          title: Column(
            children: [
              Text(
                ied.substationName,
                textAlign: TextAlign.center,
              ),
              Text(
                ied.iedName,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Column(
            children: [
              IconButton(
                onPressed: () {
                  //Adicionando metodo ao clique do botão
                  ied.toggleFavorite();
                  iedsList.updateIEDInFirebase(ied);
                },
                //Pegando icone se for favorito ou não
                icon: Consumer<IED>(
                  builder: (context, device, child) => Icon(device.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          title: Column(
            children: [
              IconButton(
                onPressed: () {
                  //Adicionando metodo ao clique do botão
                  openTaskFormModal(context);
                },
                //Icone para edição
                icon: Consumer<IED>(
                  builder: (context, device, child) => const Icon(Icons.edit),
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              iedsList.removeIED(ied);
            },
            //Pegando icone se estiver arquivado ou não
            icon: Consumer<IED>(
              builder: (context, iedArchive, child) => Icon(
                  iedArchive.isArchived
                      ? Icons.archive
                      : Icons.archive_outlined),
            ),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: ChangeNotifierProvider(
          create: (ctx) => ied,
          child: GestureDetector(
            /*child: Image.network(
                  ied.imageUrl,
                  fit: BoxFit.cover,
                ),*/
            /*child: Image.asset(
                  "images/relay.png",
                  fit: BoxFit.cover,
                ),*/
            child: imagemRelay,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.DEVICE_DETAIL_PAGE,
                  arguments: ied); // Mudar Page para IED_DATAILS_PAGE
            },
          ),
        ),
      ),
    );
  }
}
