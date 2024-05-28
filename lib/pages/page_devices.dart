import 'package:flutter/material.dart';
import '../components/grid_ied_archive.dart';
import '../model/ied.dart';
import '../model/form_ied.dart';

class MyDevicesPage extends StatefulWidget with ChangeNotifier {
  MyDevicesPage({
    super.key,
    required this.title,
  });

  @override
  State<MyDevicesPage> createState() => _MyDevicesPageState();

  final String title;
}

class _MyDevicesPageState extends State<MyDevicesPage> {
  final List<IED> _ieds = [];
  final bool _showOnlyFavorites = false;
  final Text textReg = const Text('Nenhum Dispositivo Arquivado!',
      style: TextStyle(fontSize: 20));

  void _novoIED(
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
    IED novoIED = IED(
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

    setState(() {
      _ieds.add(novoIED);
    });

    Navigator.of(context).pop();
  }

  //Modal
  void _openTaskFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return FormIED(_novoIED);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.amber),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 22),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
          ],
        ),
      ),
      /*body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Formulario de IED
              const SizedBox(
                height: 20,
              ),
              // Lista de IEDs
              _ieds.isEmpty ? textReg : const IEDArchiveGrid(),
            ],
          ),
        ),
      ),*/
      body: const IEDArchiveGrid(),
      backgroundColor: Colors.grey[100],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
