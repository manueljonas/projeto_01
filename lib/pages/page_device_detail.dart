import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/ied.dart';
import '../model/list_ied.dart';

/* class DeviceDatailPage extends StatelessWidget { */
class DeviceDatailPage extends StatefulWidget {
  DeviceDatailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DeviceDatailPage> createState() => _DeviceDatailPageState();
}

class _DeviceDatailPageState extends State<DeviceDatailPage> {
  final Map<String, Image> _imagens = {
    "relay": Image.asset(
      "images/relay.png",
      fit: BoxFit.cover,
      alignment: Alignment.center,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final IED ied = ModalRoute.of(context)!.settings.arguments as IED;
    final provider = Provider.of<IEDList>(context);

    Image imagemRelay = _imagens["relay"]!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.amber),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 22),
        leading: IconButton(
          onPressed: () {
            provider.updateIEDList(ied);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
        ),
        title: Column(
          children: [
            Text(
              "SE: ${ied.substationName}",
              style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              "IED: ${ied.iedName}",
              style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
      // body of ied page
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: imagemRelay.height,
              width: imagemRelay.width,
              child: imagemRelay,
            ),
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                "IED: ${ied.iedName}",
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
