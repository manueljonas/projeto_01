import 'dart:convert';
import 'dart:math';

import 'ied.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class IEDList with ChangeNotifier {
  //final _baseUrl = 'https://relay-calculator-default-rtdb.firebaseio.com/';
  final _baseUrl = 'https://relay-c4990-default-rtdb.firebaseio.com/';

  final List<IED> _items = [];
  bool _showFavoriteOnly = false;
  final List<String> _idsIEDs = [];

  List<IED> get items {
    // get ieds of firebase
    http.get(Uri.parse('$_baseUrl/ieds.json')).then((response) async {
      final Map<String, dynamic> data = await json.decode(response.body);
      final List<IED> loadIEDs = [];
      data.forEach((id, ied) {
        loadIEDs.add(IED(
          id: id,
          substationName: ied['substationName'],
          iedName: ied['iedName'],
          elementFault: ied['elementFault'],
          elementPickUp: ied['elementPickUp'],
          elementTimeDial: ied['elementTimeDial'],
          pattern: ied['pattern'],
          operateTime: ied['operateTime'],
          operationMessage: ied['operationMessage'],
          isFavorite: ied['isFavorite'],
          isArchived: ied['isArchived'],
        ));
      });
      _items.clear();
      _items.addAll(loadIEDs);
      notifyListeners();
    });
    return [..._items];
  }

  List<IED> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  List<IED> get archivedItems {
    return _items.where((prod) => prod.isArchived).toList();
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  // Operacao Assincrona, funciona como um espaço reservado para o resultado eventual,
  // permitindo que seu código continue a execução sem esperar a conclusão da operação.
  Future<void> addIED(IED ied) {
    final future = http.post(Uri.parse('$_baseUrl/ieds.json'),
        body: jsonEncode({
          //"id": ied.id,
          "substationName": ied.substationName,
          "iedName": ied.iedName,
          "elementFault": ied.elementFault,
          "elementPickUp": ied.elementPickUp,
          "elementTimeDial": ied.elementTimeDial,
          "pattern": ied.pattern,
          "operateTime": ied.operateTime,
          "operationMessage": ied.operationMessage,
          "isFavorite": ied.isFavorite,
          "isArchived": ied.isArchived,
        }));
    return future.then((response) {
      //print('espera a requisição acontecer');
      print(jsonDecode(response.body));
      final id = jsonDecode(response.body)['name'];
      print(response.statusCode);
      ied.id = response.body;

      _items.add(IED(
        id: id,
        substationName: ied.substationName,
        iedName: ied.iedName,
        elementFault: ied.elementFault,
        elementPickUp: ied.elementPickUp,
        elementTimeDial: ied.elementTimeDial,
        pattern: ied.pattern,
        operateTime: ied.operateTime,
        operationMessage: ied.operationMessage,
        isFavorite: ied.isFavorite,
        isArchived: ied.isArchived,
      ));
      notifyListeners();
    });
  }

  Future<void> saveIED(Map<String, Object> data) async {
    bool hasId = false;

/*    for (var i = 0; i < items.length; i++) {
      print('Element index: $i');
      if (items[i].substationName == data['substationName'] &&
          items[i].iedName == data['iedName']) {
        hasId = true;
        print('Elemento encontrado na lista (Firebase)!');
      } else {
        hasId = false;
        print('Elemento não encontrado na lista (Firebase)!');
      }
    }*/

    items.forEach(
      (element) {
        print('Element: $element');
        if (element.substationName == data['substationName'] &&
            element.iedName == data['iedName']) {
          hasId = true;
          print('Elemento encontrado na lista (Firebase)!');
        } else {
          hasId = false;
          print('Elemento não encontrado na lista (Firebase)!');
        }
      },
    );

    bool hasIsFavorite = data['isFavorite'] != null;
    bool hasIsArchived = data['isArchived'] != null;

    final ied = IED(
      id: data['id'] as String,
      substationName: data['substationName'] as String,
      iedName: data['iedName'] as String,
      elementFault: data['elementFault'] as double,
      elementPickUp: data['elementPickUp'] as double,
      elementTimeDial: data['elementTimeDial'] as double,
      pattern: data['pattern'] as String,
      operateTime: data['operateTime'] as double,
      operationMessage: data['operationMessage'] as String,
      isFavorite: hasIsFavorite ? data['isFavorite'] as bool : false,
      isArchived: hasIsArchived ? data['isArchived'] as bool : false,
    );

    print('hasId = $hasId');
    if (hasId) {
      //notifyListeners();
      return updateIED(ied);
    } else {
      //notifyListeners();
      return addIED(ied);
    }
  }

  Future<void> updateIED(IED ied) {
    int index = _items.indexWhere((device) => device.id == ied.id);

    if (index >= 0) {
      _items[index] = ied;
      updateIEDInFirebase(ied).then((_) {
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    }
    notifyListeners();
    return Future.value();
  }

  void removeIED(IED ied) {
    int index = _items.indexWhere((device) => device.id == ied.id);

/*    if (index >= 0) {
      _items.removeWhere((p) => p.id == ied.id);
      notifyListeners();
    } */
    if (index >= 0) {
      _items.removeWhere((device) => device.id == ied.id);
      removeIEDInFirebase(ied).then((_) {}).catchError((e) {
        print(e);
      });
    }
    notifyListeners();
  }

  List<String> get idsIEDs {
    return [..._idsIEDs];
  }

  List<IED> get iedsItems {
    return _items.where((device) => _idsIEDs.contains(device.id)).toList();
  }

  IED getIEDById(String id) {
    return _items.firstWhere((device) => device.id == id);
  }

  void setIdArchiveAndListener(String id) {
    if (_idsIEDs.contains(id)) {
      _idsIEDs.remove(id);
    } else {
      _idsIEDs.add(id);
    }
    notifyListeners();
  }

  void setIdArchive(String id) {
    if (_idsIEDs.contains(id)) {
      _idsIEDs.remove(id);
    } else {
      _idsIEDs.add(id);
    }
    notifyListeners();
  }

  void removeIdIEDs(String id) {
    _idsIEDs.remove(id);
    notifyListeners();
  }

  void updateIEDList(IED ied) {
    final index = _items.indexWhere((device) => device.id == ied.id);
    if (index >= 0) {
      _items[index] = ied;
    }
    notifyListeners();
  }

  Future<void> updateIEDInFirebase(IED ied) {
    final url = '$_baseUrl/ieds/${ied.id}.json';
    return http.patch(
      Uri.parse(url),
      body: jsonEncode({
        //"id": ied.id,
        "substationName": ied.substationName,
        "iedName": ied.iedName,
        "elementFault": ied.elementFault,
        "elementPickUp": ied.elementPickUp,
        "elementTimeDial": ied.elementTimeDial,
        "pattern": ied.pattern,
        "operateTime": ied.operateTime,
        "operationMessage": ied.operationMessage,
        "isFavorite": ied.isFavorite,
        "isArchived": ied.isArchived,
      }),
    );
  }

  Future<void> removeIEDInFirebase(IED ied) {
    final url = '$_baseUrl/ieds/${ied.id}.json';
    notifyListeners();
    return http.delete(Uri.parse(url));
  }
}
