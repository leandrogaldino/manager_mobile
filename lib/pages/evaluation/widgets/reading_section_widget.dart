// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:manager_mobile/core/locator.dart';

import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:validatorless/validatorless.dart';

class ReadingSectionWidget extends StatefulWidget {
  const ReadingSectionWidget({
    super.key,
    required this.evaluation,
  });

  final EvaluationModel evaluation;

  @override
  State<ReadingSectionWidget> createState() => _ReadingSectionWidgetState();
}

class _ReadingSectionWidgetState extends State<ReadingSectionWidget> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController customerEC;
  int? selectedItem = 1;

  late final List<PersonModel> persons;
  PersonModel? selectedPerson;

  @override
  void dispose() {
    customerEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var s = Locator.get<PersonService>();
      persons = await s.getAll();
    });

    customerEC = TextEditingController();
    customerEC.addListener(() {
      if (selectedPerson != null && customerEC.text != selectedPerson!.shortName) {
        selectedPerson = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 12,
        children: [
          TypeAheadField<PersonModel>(
            controller: customerEC,
            builder: (context, controller, focusNode) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                validator: Validatorless.required('Cliente obrigatório'),
                decoration: InputDecoration(labelText: 'Cliente'),
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
              selectedPerson = suggestion;
            },
            suggestionsCallback: (query) async {
              return persons.where((item) => item.shortName.toLowerCase().contains(query.toLowerCase())).toList();
            },
          ),
          TextFormField(
            controller: customerEC,
            validator: Validatorless.required('m'),
            decoration: InputDecoration(labelText: 'Cliente'),
          ),
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
