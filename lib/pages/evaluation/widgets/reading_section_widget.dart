import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';
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
  late final TextEditingController customerEC;
  late final EvaluationController evaluationController;

  int? selectedItem = 1;

  @override
  void dispose() {
    customerEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    evaluationController = Locator.get<EvaluationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await evaluationController.fetchCustomers().asyncLoader();
    });

    customerEC = TextEditingController();
    customerEC.addListener(() {
      if (evaluationController.selectedCustomer != null && customerEC.text != evaluationController.selectedCustomer!.shortName) {
        evaluationController.setSelectedCustomer(null);
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
              listenable: evaluationController,
              builder: (context, child) {
                return TypeAheadField<PersonModel>(
                  controller: customerEC,
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório!';
                        }
                        if (evaluationController.selectedCustomer == null) {
                          return 'Selecione um cliente';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Cliente'),
                      style: TextStyle(color: evaluationController.selectedCustomer == null ? Colors.blue : Colors.orange), // Cor do texto digitado
                    );
                  },
                  itemBuilder: (context, person) {
                    return ListTile(
                      title: Text(person.shortName),
                      subtitle: Text(person.document),
                    );
                  },
                  onSelected: (suggestion) {
                    customerEC.text = suggestion.shortName;
                    evaluationController.setSelectedCustomer(suggestion);
                  },
                  suggestionsCallback: (query) async {
                    return evaluationController.customers.where((item) => item.shortName.toLowerCase().contains(query.toLowerCase())).toList();
                  },
                );
              }),
          TextFormField(decoration: InputDecoration(labelText: 'Compressor')),
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
