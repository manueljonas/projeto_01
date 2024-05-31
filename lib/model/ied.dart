import 'package:flutter/cupertino.dart';

class IED with ChangeNotifier {
  String id;
  final String substationName;
  final String iedName;
  double elementFault;
  double elementPickUp;
  double elementTimeDial;
  String pattern;
  double operateTime;
  String operationMessage;
  bool isFavorite;
  bool isArchived;

  IED({
    required this.id,
    required this.substationName,
    required this.iedName,
    required this.elementFault,
    required this.elementPickUp,
    required this.elementTimeDial,
    required this.pattern,
    required this.operateTime,
    required this.operationMessage,
    required this.isFavorite,
    required this.isArchived,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void toggleArchive() {
    isArchived = !isArchived;
    notifyListeners();
  }

  startsWith(String id) {}
}
