import 'package:flutter/material.dart';
//import 'package:projeto_01/main.dart';
//import 'package:projeto_01/page_devices.dart';
//import 'package:projeto_01/page_devicedetails.dart';
//import 'package:projeto_01/page_protectiongraph.dart';
import '../model/ied.dart';
import '../model/form_ied.dart';

class MyHelp extends StatelessWidget {
  const MyHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HelpPage extends StatefulWidget {
  const HelpPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  final List<IED> _ieds = [];
  final Text textReg =
      const Text('Nenhum Cálculo Registrado!', style: TextStyle(fontSize: 20));

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

  final String _selectedPage = 'Home';

  //int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Devices',
      style: optionStyle,
    ),
    Text(
      'Help',
      style: optionStyle,
    ),
  ];

  /*void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _selectedPage = 'Home';
        Navigator.of(context).pushNamed('/home-page');
      } else if (_selectedIndex == 1) {
        _selectedPage = 'Devices';
        Navigator.of(context).pushNamed('/devices-page');
      } else {
        _selectedPage = 'Help';
        //Navigator.of(context).pushNamed('/help-page');
      }
    });
  }*/

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
            //BackButton(onPressed: () {}, color: Colors.amber),
            Text(widget.title),
            /*IconButton(
              onPressed: () => _openTaskFormModal(context),
              icon: const Icon(Icons.add),
              color: Colors.amber,
            ),*/
          ],
        ),
      ),
      /*drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('/home-page');
                  _selectedPage = 'Home';
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.developer_board_outlined),
              title: const Text('Devices'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('/devices-page');
                  _selectedPage = 'Devices';
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                setState(() {
                  //Navigator.of(context).pushNamed('/help-page');
                  _selectedPage = 'Help';
                  _selectedIndex = 2;
                });
              },
            ),
          ],
        ),
      ),*/
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            children: [
              /*Center(
                child: Text(_selectedPage),
              ),
              Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),*/
              Text(
                'Pagina de Ajuda do Software.',
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              // Formulario de IED
              SizedBox(
                height: 20,
              ),
              // Lista de IEDs
              //_ieds.isEmpty ? textReg : ListIED(listIEDs: _ieds),
            ],
          ),
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.developer_board_outlined),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Help',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),*/
      backgroundColor: Colors.grey[100],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
