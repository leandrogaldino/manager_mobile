import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:validatorless/validatorless.dart';

class ReadingSectionWidget extends StatefulWidget {
  const ReadingSectionWidget({
    super.key,
    required this.evaluation,
    required this.formKey,
  });

  final EvaluationModel evaluation;
  final GlobalKey<FormState> formKey;

  @override
  State<ReadingSectionWidget> createState() => _ReadingSectionWidgetState();
}

class _ReadingSectionWidgetState extends State<ReadingSectionWidget> {
  late final TextEditingController _customerEC;
  late final TextEditingController _compressorEC;
  late final EvaluationController _evaluationController;

  int? selectedItem = 1;

  @override
  void dispose() {
    _customerEC.dispose();
    _compressorEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _evaluationController.fetchCustomers().asyncLoader();
    });
    _customerEC = TextEditingController();
    _customerEC.addListener(() {
      if (_evaluationController.selectedCustomer != null && _customerEC.text != _evaluationController.selectedCustomer!.shortName) {
        _evaluationController.setSelectedCustomer(null);
        _evaluationController.setSelectedCompressor(null);
        _compressorEC.text = '';
        //TODO: Os Campos da avaliação nao podem ser final, para poder fazer o bind no listen
      }
    });

    _compressorEC = TextEditingController();
    _compressorEC.addListener(() {
      if (_evaluationController.selectedCompressor != null && _compressorEC.text != _evaluationController.selectedCompressor!.compressorName) {
        _evaluationController.setSelectedCompressor(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        spacing: 12,
        children: [
          ListenableBuilder(
            listenable: _evaluationController,
            builder: (context, child) {
              return TypeAheadField<PersonModel>(
                controller: _customerEC,
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('O cliente é obrigatório'),
                        (value) {
                          if (_evaluationController.selectedCustomer == null) {
                            return 'Selecione um cliente';
                          }
                          return null;
                        }
                      ],
                    ),
                    decoration: InputDecoration(labelText: 'Cliente'),
                    style: TextStyle(color: _evaluationController.selectedCustomer == null ? Colors.blue : Colors.orange), // Cor do texto digitado
                  );
                },
                itemBuilder: (context, person) {
                  return ListTile(
                    title: Text(person.shortName),
                    subtitle: Text(person.document),
                  );
                },
                onSelected: (suggestion) {
                  _customerEC.text = suggestion.shortName;
                  _evaluationController.setSelectedCustomer(suggestion);

                  // Limpa o compressor ao alterar o cliente
                  _compressorEC.clear();
                  _evaluationController.setSelectedCompressor(null);
                },
                suggestionsCallback: (query) async {
                  return _evaluationController.customers.where((item) => item.shortName.toLowerCase().contains(query.toLowerCase())).toList();
                },
              );
            },
          ),
          ListenableBuilder(
            listenable: _evaluationController,
            builder: (context, child) {
              return TypeAheadField<CompressorModel>(
                key: ValueKey(_evaluationController.selectedCustomer?.id),
                controller: _compressorEC,
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    enabled: _evaluationController.selectedCustomer != null,
                    controller: controller,
                    focusNode: focusNode,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('O compressor é obrigatório'),
                        (value) {
                          if (_evaluationController.selectedCompressor == null) {
                            return 'Selecione um compressor';
                          }
                          return null;
                        }
                      ],
                    ),
                    decoration: InputDecoration(labelText: 'Compressor'),
                    style: TextStyle(color: _evaluationController.selectedCompressor == null ? Colors.blue : Colors.orange), // Cor do texto digitado
                  );
                },
                itemBuilder: (context, compressor) {
                  return ListTile(
                    title: Text(compressor.compressorName),
                    subtitle: Text(compressor.serialNumber),
                  );
                },
                onSelected: (suggestion) {
                  _compressorEC.text = suggestion.compressorName;
                  _evaluationController.setSelectedCompressor(suggestion);
                },
                suggestionsCallback: (query) async {
                  return _evaluationController.selectedCustomer?.compressors.where((item) => item.compressorName.toLowerCase().contains(query.toLowerCase())).toList();
                },
              );
            },
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Horímetro',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: selectedItem,
                  decoration: InputDecoration(labelText: 'Tipo de Óleo'),
                  items: [
                    DropdownMenuItem<int>(
                      value: 0, // Valor do item
                      child: Text(
                        'Mineral',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 1, // Valor do item
                      child: Text(
                        'Semi Sintético',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 2, // Valor do item
                      child: Text(
                        'Sintético',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                  onChanged: (item) {
                    setState(() {
                      selectedItem = item;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Filtro de Ar',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Filtro de Óleo',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Separador',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Óleo',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Parecer Técnico'),
            maxLines: 5,
          ),
          TextFormField(decoration: InputDecoration(labelText: 'Responsável')),
        ],
      ),
    );
  }
}
