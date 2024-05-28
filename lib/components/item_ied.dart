import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/ied.dart';
import '../model/list_ied.dart';
import '../utils/app_routes.dart';

class IEDItem extends StatelessWidget {
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
      listen: false,
    );

    final iedsList = Provider.of<IEDList>(
      context,
      listen: false,
    );

    //final ied = context.watch<IED>();
    var isFavorite = context.select<IED, bool>((ied) => ied.isFavorite);
    Image imagemRelay = _imagens["relay"]!;

    return ClipRRect(
      //corta de forma arredondada o elemento de acordo com o BorderRaius
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              //Adicionando metodo ao clique do botão
              ied.toggleFavorite();
              iedsList.updateIEDInFirebase(ied);
            },
            //Pegando icone se for favorito ou não
            icon: Consumer<IED>(
              builder: (context, device, child) => Icon(
                  device.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            ied.iedName,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              //Adicionando metodo ao clique do botão
              ied.toggleArchive();
              //iedsList.updateIEDInFirebase(ied);
              if (!ied.isArchived) {
                iedsList.removeIED(ied);
              }
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
              Navigator.of(context).pushNamed(AppRoutes.HELP_PAGE,
                  arguments: ied); // Mudar Page para IED_DATAILS_PAGE
            },
          ),
        ),
      ),
    );
  }
}
