import 'package:flutter/material.dart';
import 'package:projeto_01/page_devices.dart';
import 'package:projeto_01/page_help.dart';
//import 'package:projeto_01/page_devicedetails.dart';
//import 'package:projeto_01/page_protectiongraph.dart';
import 'ied.dart';
import 'form_ied.dart';
import 'list_ied.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relay Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Relay Calculator'),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const MyHomePage(title: 'Relay Calculator'),
        '/devices': (context) => const DevicesPage(title: 'Devices'),
        '/help': (context) => const HelpPage(title: 'Help'),
        //'/devicedetails': (context) => const DeviceDetailsPage(title: 'Device Details'),
        //'/protectiongraph': (context) => const ProtectionGraphPage(title: 'Protection Graph'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final List<IED> _ieds = [];
  final Text textReg =
      const Text('Nenhuma Cálculo Registrado!', style: TextStyle(fontSize: 20));

  void _novoIED(
    String id,
    double elementFault,
    double elementPickUp,
    double elementTimeDial,
    String pattern,
    double operateTime,
    String operationMessage,
  ) {
    IED novoIED = IED(
      id: id,
      elementFault: elementFault,
      elementPickUp: elementPickUp,
      elementTimeDial: elementTimeDial,
      pattern: pattern,
      operateTime: operateTime,
      operationMessage: operationMessage,
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

  String _selectedPage = 'Home';

  int _selectedIndex = 0;
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        if (_selectedIndex != 0) Navigator.of(context).pushNamed('/home');
        _selectedPage = 'Home';
      } else if (_selectedIndex == 1) {
        _selectedPage = 'Devices';
        Navigator.of(context).pushNamed('/devices');
      } else {
        _selectedPage = 'Help';
        Navigator.of(context).pushNamed('/help');
      }
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
            //BackButton(onPressed: () {}, color: Colors.amber),
            Text(widget.title),
            IconButton(
              onPressed: () => _openTaskFormModal(context),
              icon: const Icon(Icons.add),
              color: Colors.amber,
            ),
          ],
        ),
      ),
      drawer: Drawer(
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
                  if (_selectedPage != 'Home')
                    Navigator.of(context).pushNamed('/home');
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
                  Navigator.of(context).pushNamed('/devices');
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
                  Navigator.of(context).pushNamed('/help');
                  _selectedPage = 'Help';
                  _selectedIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /*Center(
                child: Text(_selectedPage),
              ),
              Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),*/
              // Formulario de IED
              const SizedBox(
                height: 20,
              ),
              // Lista de IEDs
              _ieds.isEmpty ? textReg : ListIED(listIEDs: _ieds),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
      backgroundColor: Colors.grey[100],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
