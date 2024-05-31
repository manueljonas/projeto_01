import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model/ied.dart';
import 'model/list_ied.dart';
import 'pages/page_device_detail.dart';
import 'pages/page_devices.dart';
import 'pages/page_help.dart';
import 'pages/page_home.dart';
import 'pages/page_login.dart';
import 'utils/app_routes.dart';

//import '../page_devicedetails.dart';
//import '../page_protectiongraph.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LoginPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => MyHomePage(title: 'Relay Calculator'),
          ),
          ChangeNotifierProvider(
            create: (context) => MyDevicesPage(title: 'Archived Devices'),
          ),
          ChangeNotifierProvider(
            create: (context) => IEDList(),
          ),
          ChangeNotifierProvider(
            create: (context) => IED(
                id: '',
                substationName: 'substationName',
                iedName: 'iedName',
                elementFault: 0,
                elementPickUp: 0,
                elementTimeDial: 0,
                pattern: 'pattern',
                operateTime: 0,
                operationMessage: 'operationMessage',
                isFavorite: false,
                isArchived: false),
          ),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Initialized default app $app');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDefault();
    return MaterialApp(
      title: 'Relay Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home-page',
      //home: MyHomePage(title: 'Relay Calculator'),
      routes: {
        AppRoutes.HOME_PAGE: (ctx) => MyHomePage(title: 'Relay Calculator'),
        AppRoutes.LOGIN_PAGE: (ctx) => LoginPage(),
        AppRoutes.DEVICES_PAGE: (ctx) =>
            MyDevicesPage(title: 'Archived Devices'),
        AppRoutes.HELP_PAGE: (ctx) => const HelpPage(title: 'Help'),
        AppRoutes.DEVICE_DETAIL_PAGE: (ctx) => DeviceDatailPage(),
/*        AppRoutes.PROTECTION_GRAPH_PAGE: (ctx) =>
            const ProtectionGraphPage(title: 'Protection Graph'), */
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
