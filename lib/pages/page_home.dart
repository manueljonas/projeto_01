import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model/ied.dart';
import '../model/form_ied.dart';
import '../components/grid_ied.dart';
import '../utils/app_routes.dart';
import '../pages/page_login.dart';

class MyHomePage extends StatefulWidget with ChangeNotifier {
  MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  final int _selectedIndex = 0;
  final String title;
}

class _MyHomePageState extends State<MyHomePage> {
  final List<IED> _ieds = [];
  final bool _showOnlyFavorites = false;
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

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<MyHomePage>(context);
    final provider = Provider.of<MyHomePage>(
      context,
      listen: false,
    );

    void onItemTapped(int index) {
      setState(() {
        //print('Valor do index =  $index');
        if (index == 0) {
          if (index != 0) {
            Navigator.of(context).pushNamed('/home-page');
          }
        } else if (index == 1) {
          if (LoginPage().user == null) {
            Navigator.of(context).pushNamed(
              AppRoutes.LOGIN_PAGE,
            );
          } else {
            Navigator.of(context).pushNamed('/devices-page');
          }
        } else {
          Navigator.of(context).pushNamed('/help-page');
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.amber),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 22),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            IconButton(
              onPressed: () => (LoginPage().user == null)
                  ? {
                      Navigator.of(context).pushNamed(
                        AppRoutes.LOGIN_PAGE,
                      )
                    }
                  : _openTaskFormModal(context),
              icon: const Icon(Icons.add),
              color: Colors.amber,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.LOGIN_PAGE);
              },
              icon: const Icon(Icons.login),
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
                'Relay Calculator',
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
                if (provider._selectedIndex != 0) {
                  Navigator.of(context).pushNamed('/home-page');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.developer_board_outlined),
              title: const Text('Devices'),
              onTap: () {
                if (LoginPage().user == null) {
                  Navigator.of(context).pushNamed(
                    AppRoutes.LOGIN_PAGE,
                  );
                } else {
                  Navigator.of(context).pushNamed('/devices-page');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                Navigator.of(context).pushNamed('/help-page');
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
              // Formulario de IED
              const SizedBox(
                height: 20,
              ),
              // Lista de IEDs
              _ieds.isEmpty
                  ? textReg
                  : IEDGrid(
                      listIEDs: _ieds, showOnlyFavorites: _showOnlyFavorites),
            ],
          ),
        ),
      ),
      // Lista de IEDs para Serem Arquivados
      //body: _ieds.isEmpty ? textReg : IEDArchiveGrid(_showOnlyFavorites),
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
        currentIndex: provider._selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTapped,
      ),
      backgroundColor: Colors.grey[100],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
