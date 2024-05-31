import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/item_ied.dart';
import '../model/ied.dart';
import '../model/list_ied.dart';

class IEDArchiveGrid extends StatelessWidget {
  // final bool _showOnlyFavorites;

  const IEDArchiveGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IEDList>(context);
    final List<IED> loadIEDs = provider.items;
    //_showOnlyFavorites ? provider.favoriteItems : provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadIEDs.length,
      //# IEDItem vai receber a partir do Provider
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //create: (ctx) => IED(),
        value: loadIEDs[i],
        //child: IEDItem(ied: loadedIEDs[i]),
        child: IEDItem(listIEDs: loadIEDs),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //2 IEDs por linha
        childAspectRatio: 1 / 1, //dimensão de cada elemento
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
