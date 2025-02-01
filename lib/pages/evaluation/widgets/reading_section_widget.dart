import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'package:manager_mobile/pages/evaluation/enums/oil_types.dart';
import 'package:manager_mobile/pages/evaluation/enums/part_types.dart';
import 'package:manager_mobile/pages/evaluation/validation/evaluation_validators.dart';
import 'package:validatorless/validatorless.dart';

class ReadingSectionWidget extends StatefulWidget {
  const ReadingSectionWidget({
    super.key,
    required this.evaluation,
    required this.formKey,
    required this.source,
  });

  final EvaluationModel evaluation;
  final EvaluationSource source;
  final GlobalKey<FormState> formKey;

  @override
  State<ReadingSectionWidget> createState() => _ReadingSectionWidgetState();
}

class _ReadingSectionWidgetState extends State<ReadingSectionWidget> {
  late final EvaluationController _evaluationController;
  late final TextEditingController _customerEC;
  late final TextEditingController _compressorEC;
  late final TextEditingController _serialNumberEC;
  late final TextEditingController _horimeterEC;
  late final TextEditingController _airFilterEC;
  late final TextEditingController _oilFilterEC;
  late final TextEditingController _separatorEC;
  late final TextEditingController _oilEC;
  late final TextEditingController _adviceEC;
  late final TextEditingController _responsibleEC;

  @override
  void dispose() {
    _customerEC.dispose();
    _compressorEC.dispose();
    _serialNumberEC.dispose();
    _horimeterEC.dispose();
    _airFilterEC.dispose();
    _oilFilterEC.dispose();
    _separatorEC.dispose();
    _oilEC.dispose();
    _adviceEC.dispose();
    _responsibleEC.dispose();
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
        _serialNumberEC.text = '';
      }
    });
    _compressorEC = TextEditingController();
    _compressorEC.addListener(() {
      if (_evaluationController.selectedCompressor != null && _compressorEC.text != _evaluationController.selectedCompressor!.compressorName) {
        _evaluationController.setSelectedCompressor(null);
        _serialNumberEC.text = '';
      }
    });
    _serialNumberEC = TextEditingController();
    _horimeterEC = TextEditingController();
    _airFilterEC = TextEditingController();
    _oilFilterEC = TextEditingController();
    _separatorEC = TextEditingController();
    _oilEC = TextEditingController();
    _adviceEC = TextEditingController();
    _responsibleEC = TextEditingController();

    if (widget.source != EvaluationSource.fromNew) _fillForm();
  }

  _fillForm() {
    _customerEC.text = widget.evaluation.customer!.shortName;
    _compressorEC.text = widget.evaluation.compressor!.compressorName;
    _serialNumberEC.text = widget.evaluation.compressor!.serialNumber;
    _horimeterEC.text = widget.evaluation.horimeter == null ? '' : widget.evaluation.horimeter.toString();
    _airFilterEC.text = widget.evaluation.airFilter == null ? '' : widget.evaluation.airFilter.toString();
    _oilFilterEC.text = widget.evaluation.oilFilter == null ? '' : widget.evaluation.oilFilter.toString();
    _separatorEC.text = widget.evaluation.separator == null ? '' : widget.evaluation.separator.toString();
    _oilEC.text = widget.evaluation.oil == null ? '' : widget.evaluation.oil.toString();
    _adviceEC.text = widget.evaluation.advice ?? '';
    _responsibleEC.text = widget.evaluation.responsible ?? '';
    _evaluationController.setSelectedCustomer(widget.evaluation.customer);
    _evaluationController.setSelectedCompressor(widget.evaluation.compressor);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _evaluationController,
        builder: (context, child) {
          return Form(
            key: widget.formKey,
            child: Column(
              spacing: 12,
              children: [
                TypeAheadField<PersonModel>(
                  hideOnEmpty: true,
                  controller: _customerEC,
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: controller,
                      readOnly: widget.source != EvaluationSource.fromNew,
                      focusNode: focusNode,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Campo obrigatório'),
                          EvaluationValidators.hasCustomer(_evaluationController.selectedCustomer, 'Selecione um item'),
                        ],
                      ),
                      decoration: InputDecoration(labelText: 'Cliente'),
                      style: TextStyle(color: _evaluationController.selectedCustomer == null ? Colors.blue : Colors.orange), // Cor do texto digitado
                      onChanged: (value) {},
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
                    _compressorEC.clear();
                    _serialNumberEC.clear();
                    _evaluationController.setSelectedCompressor(null);
                  },
                  suggestionsCallback: (query) async {
                    if (widget.source != EvaluationSource.fromNew) return [];
                    return _evaluationController.customers.where((item) => item.shortName.toLowerCase().contains(query.toLowerCase())).toList();
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TypeAheadField<CompressorModel>(
                        hideOnEmpty: true,
                        key: ValueKey(_evaluationController.selectedCustomer?.id),
                        controller: _compressorEC,
                        builder: (context, controller, focusNode) {
                          return TextFormField(
                            readOnly: widget.source != EvaluationSource.fromNew,
                            controller: controller,
                            focusNode: focusNode,
                            validator: Validatorless.multiple(
                              [
                                EvaluationValidators.requiredCompressor(_evaluationController.selectedCustomer, _evaluationController.selectedCompressor, 'Campo obrigatório'),
                                EvaluationValidators.hasCompressor(_evaluationController.selectedCustomer, _evaluationController.selectedCompressor, 'Selecione um item'),
                              ],
                            ),
                            decoration: InputDecoration(labelText: 'Compressor'),
                            style: TextStyle(color: _evaluationController.selectedCompressor == null ? Colors.blue : Colors.orange),
                            onChanged: (value) {
                              widget.evaluation.compressor = null;
                            },
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
                          _serialNumberEC.text = suggestion.serialNumber;
                          _evaluationController.setSelectedCompressor(suggestion);
                          widget.evaluation.compressor = _evaluationController.selectedCompressor;
                        },
                        suggestionsCallback: (query) async {
                          if (widget.source != EvaluationSource.fromNew) return [];
                          return _evaluationController.selectedCustomer?.compressors.where((item) => item.compressorName.toLowerCase().contains(query.toLowerCase())).toList();
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _serialNumberEC,
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Nº Série'),
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _horimeterEC,
                        readOnly: widget.source == EvaluationSource.fromSaved,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: InputDecoration(
                          labelText: 'Horímetro',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => widget.evaluation.horimeter = value == '' ? 0 : int.parse(value),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<OilTypes>(
                        alignment: AlignmentDirectional.center,
                        value: _evaluationController.selectedOilType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Óleo',
                        ),
                        items: OilTypes.values.map((oilType) {
                          return DropdownMenuItem<OilTypes>(
                            value: oilType,
                            child: Text(
                              oilType.stringValue,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          );
                        }).toList(),
                        onChanged: widget.source != EvaluationSource.fromSaved
                            ? (oilType) {
                                _evaluationController.setOilType(oilType!);
                              }
                            : null,
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _airFilterEC,
                        readOnly: widget.source == EvaluationSource.fromSaved,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                        validator: Validatorless.multiple(
                          [
                            Validatorless.required('Campo obrigatório'),
                            EvaluationValidators.validPartTimeRange(
                              _evaluationController.selectedOilType,
                              PartTypes.airFilter,
                            ),
                          ],
                        ),
                        decoration: InputDecoration(
                          labelText: 'Filtro de Ar',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => widget.evaluation.airFilter = int.tryParse(value) ?? 0,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _oilFilterEC,
                        readOnly: widget.source == EvaluationSource.fromSaved,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                        validator: Validatorless.multiple(
                          [
                            Validatorless.required('Campo obrigatório'),
                            EvaluationValidators.validPartTimeRange(
                              _evaluationController.selectedOilType,
                              PartTypes.oilFilter,
                            ),
                          ],
                        ),
                        decoration: InputDecoration(
                          labelText: 'Filtro de Óleo',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => widget.evaluation.oilFilter = int.tryParse(value) ?? 0,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _separatorEC,
                        readOnly: widget.source == EvaluationSource.fromSaved,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                        validator: Validatorless.multiple(
                          [
                            Validatorless.required('Campo obrigatório'),
                            EvaluationValidators.validPartTimeRange(
                              _evaluationController.selectedOilType,
                              PartTypes.separator,
                            ),
                          ],
                        ),
                        decoration: InputDecoration(
                          labelText: 'Separador',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => widget.evaluation.separator = int.tryParse(value) ?? 0,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _oilEC,
                        readOnly: widget.source == EvaluationSource.fromSaved,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                        validator: Validatorless.multiple(
                          [
                            Validatorless.required('Campo obrigatório'),
                            EvaluationValidators.validPartTimeRange(
                              _evaluationController.selectedOilType,
                              PartTypes.oil,
                            ),
                          ],
                        ),
                        decoration: InputDecoration(
                          labelText: 'Óleo',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => widget.evaluation.oil = int.tryParse(value) ?? 0,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _adviceEC,
                  readOnly: widget.source == EvaluationSource.fromSaved,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: 'Parecer Técnico'),
                  maxLines: 5,
                  onChanged: (value) => widget.evaluation.advice = value,
                ),
                TextFormField(
                  controller: _responsibleEC,
                  readOnly: widget.source == EvaluationSource.fromSaved,
                  textCapitalization: TextCapitalization.words,
                  validator: Validatorless.required('Campo obrigatório'),
                  decoration: InputDecoration(labelText: 'Responsável'),
                  onChanged: (value) => widget.evaluation.advice = value,
                ),
              ],
            ),
          );
        });
  }
}
