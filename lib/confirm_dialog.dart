import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onConfirm;
  final Function() onCancel;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}
