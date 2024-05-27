import 'package:flutter/cupertino.dart';

class IED with ChangeNotifier {
  String id;
  final String substationName;
  final String iedName;
  final double elementFault;
  final double elementPickUp;
  final double elementTimeDial;
  final String pattern;
  final double operateTime;
  final String operationMessage;
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
}
