import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_01/model/list_ied.dart';
import 'package:provider/provider.dart';

import '../components/iecdt.dart';
import '../components/iecei.dart';
import '../components/ieclti.dart';
import '../components/iecni.dart';
import '../components/iecvi.dart';
import '../model/ied.dart';

class FormIED extends StatefulWidget {
  Function(
    String,
    String,
    String,
    double,
    double,
    double,
    String,
    double,
    String,
    bool,
    bool,
  ) onSubmit;
  FormIED(this.onSubmit, {super.key});

  @override
  State<FormIED> createState() => _FormIEDState();
}

class _FormIEDState extends State<FormIED> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  // Variáveis para os parâmetros do IED
  final String _id = '';
  String _substationName = '';
  String _iedName = '';
  double _correnteFalta = 0.0;
  double _correntePickup = 0.0;
  double _tempoAjuste = 0.0;
  String _padrao = 'IECDT';
  final bool _isFavorite = false;
  final bool _isArchived = false;

  // Variáveis para o resultado
  double _tempoAtuacao = 0.0;
  String _mensagemAtuacao = '';

  // Função para calcular o tempo de atuação
  void _calcularTempoAtuacao() {
    double t = 0;
    String mensagem = '';

    if (_padrao == 'IECDT') {
      t = IECDT().timeToOperate(_correntePickup, _correnteFalta, _tempoAjuste);
    } else if (_padrao == 'IECNI') {
      t = IECNI().timeToOperate(_correntePickup, _correnteFalta, _tempoAjuste);
    } else if (_padrao == 'IECVI') {
      t = IECVI().timeToOperate(_correntePickup, _correnteFalta, _tempoAjuste);
    } else if (_padrao == 'IECEI') {
      t = IECEI().timeToOperate(_correntePickup, _correnteFalta, _tempoAjuste);
    } else if (_padrao == 'IECLTI') {
      t = IECLTI().timeToOperate(_correntePickup, _correnteFalta, _tempoAjuste);
    } else {
      t = double.infinity;
    }

    if (t >= 0 && t < double.infinity) {
      mensagem = "Partida de Protecao";
    } else {
      t = double.infinity;
      mensagem = "Sem Partida de Protecao";
    }

    setState(() {
      _tempoAtuacao = t;
      _mensagemAtuacao = mensagem;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final ied = arg as IED;
        _formData['id'] = ied.id;
        _formData['substationName'] = ied.substationName;
        _formData['iedName'] = ied.iedName;
        _formData['elementFault'] = ied.elementFault;
        _formData['elementPickUp'] = ied.elementPickUp;
        _formData['elementTimeDial'] = ied.elementTimeDial;
        _formData['pattern'] = ied.pattern;
        _formData['operateTime'] = ied.operateTime;
        _formData['operationMessage'] = ied.operationMessage;
        _formData['isFavorite'] = ied.isFavorite;
        _formData['isArchived'] = ied.isArchived;
      }
    }
  }

  void _submitForm() {
    bool hasId = (_id != '');
    //final id = _id;
    final id = hasId ? _id : Random().nextDouble().toString();
    final substationName = _substationName;
    final iedName = _iedName;
    final correnteFalta = _correnteFalta;
    final correntePickup = _correntePickup;
    final tempoAjuste = _tempoAjuste;
    final padrao = _padrao;
    final isFavorite = _isFavorite;
    final isArchived = _isArchived;
    final tempoAtuacao = _tempoAtuacao;
    final mensagemAtuacao = _mensagemAtuacao;

    if (mensagemAtuacao.isEmpty) {
      return;
    }

    //passando dado para componente pai
    widget.onSubmit(
      id,
      substationName,
      iedName,
      correnteFalta,
      correntePickup,
      tempoAjuste,
      padrao,
      tempoAtuacao,
      mensagemAtuacao,
      isFavorite,
      isArchived,
    );
/*
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Provider.of<IEDList>(
      context,
      listen: false,
    ).saveIED(_formData).then((value) {
      Navigator.of(context).pop();
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 22),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.amber),
            const Text(
              "Registro",
              style: TextStyle(color: Colors.amber),
            ),
            IconButton(
              onPressed: () {
                _submitForm();
              },
              icon: const Icon(Icons.add),
              color: Colors.amber,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Campo para o nome da subestação
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome da Subestação",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Digite o nome da Subestação";
                  }
                  return null;
                },
                onSaved: (value) {
                  _substationName = value!;
                },
              ),
              // Campo para o nome do Dispositivo
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "TAG do IED",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Digite o código operacional do IED";
                  }
                  return null;
                },
                onSaved: (value) {
                  _iedName = value!;
                },
              ),
              // Campo para a corrente de falta
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Corrente (A) de Falta",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Digite a corrente de falta";
                  }
                  return null;
                },
                onSaved: (value) {
                  _correnteFalta = double.parse(value!);
                },
              ),
              // Campo para a corrente de pickup
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Corrente (A) de Pickup",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Digite a corrente de pickup";
                  }
                  return null;
                },
                onSaved: (value) {
                  _correntePickup = double.parse(value!);
                },
              ),
              // Campo para o tempo de ajuste
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Tempo de Ajuste (s)",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Digite o tempo de ajuste";
                  }
                  return null;
                },
                onSaved: (value) {
                  _tempoAjuste = double.parse(value!);
                },
              ),
              // Dropdown para o padrão
              DropdownButtonFormField<String>(
                value: _padrao,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: "IECDT",
                    child: Text("IECDT"),
                  ),
                  DropdownMenuItem<String>(
                    value: "IECNI",
                    child: Text("IECNI"),
                  ),
                  DropdownMenuItem<String>(
                    value: "IECVI",
                    child: Text("IECVI"),
                  ),
                  DropdownMenuItem<String>(
                    value: "IECEI",
                    child: Text("IECEI"),
                  ),
                  DropdownMenuItem<String>(
                    value: "IECLTI",
                    child: Text("IECLTI"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _padrao = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Botão para calcular
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _calcularTempoAtuacao();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.amber,
                  backgroundColor:
                      Colors.black, // Text Color (Foreground color)
                ),
                child: const Text("Calcular"),
              ),
              // Resultado
              Text(
                "Tempo de Atuação: ${_tempoAtuacao.toStringAsFixed(3)} s",
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                //MensagemAtuacaoState()._mensagemAtuacaoX,
                _mensagemAtuacao,
                style: const TextStyle(fontSize: 18.0, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
