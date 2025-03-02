import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/person_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/compressor_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/core/enums/part_types.dart';
import 'package:manager_mobile/pages/evaluation/validation/evaluation_validators.dart';
import 'package:validatorless/validatorless.dart';

class ReadingSectionWidget extends StatefulWidget {
  const ReadingSectionWidget({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<ReadingSectionWidget> createState() => _ReadingSectionWidgetState();
}

class _ReadingSectionWidgetState extends State<ReadingSectionWidget> {
  late final EvaluationController _evaluationController;
  late final PersonController _personController;
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
    _personController = Locator.get<PersonController>();
    _customerEC = TextEditingController();
    _customerEC.addListener(() {
      if (_evaluationController.evaluation!.customer != null && _customerEC.text != _evaluationController.evaluation!.customer!.shortName) {
        _evaluationController.evaluation!.customer = null;
        _evaluationController.updateCompressor(null);
        _compressorEC.text = '';
        _serialNumberEC.text = '';
      }
    });
    _compressorEC = TextEditingController();
    _compressorEC.addListener(() {
      if (_evaluationController.evaluation!.compressor != null && _compressorEC.text != _evaluationController.evaluation!.compressor!.compressorName) {
        _evaluationController.updateCompressor(null);
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

    if (_evaluationController.source != SourceTypes.fromNew) _fillForm();
  }

  _fillForm() {
    _customerEC.text = _evaluationController.evaluation!.customer!.shortName;
    _compressorEC.text = _evaluationController.evaluation!.compressor!.compressorName;
    _serialNumberEC.text = _evaluationController.evaluation!.compressor!.serialNumber;
    _horimeterEC.text = _evaluationController.evaluation!.horimeter == null ? '' : _evaluationController.evaluation!.horimeter.toString();
    _airFilterEC.text = _evaluationController.evaluation!.airFilter == null ? '' : _evaluationController.evaluation!.airFilter.toString();
    _oilFilterEC.text = _evaluationController.evaluation!.oilFilter == null ? '' : _evaluationController.evaluation!.oilFilter.toString();
    _separatorEC.text = _evaluationController.evaluation!.separator == null ? '' : _evaluationController.evaluation!.separator.toString();
    _oilEC.text = _evaluationController.evaluation!.oil == null ? '' : _evaluationController.evaluation!.oil.toString();
    _adviceEC.text = _evaluationController.evaluation!.advice ?? '';
    _responsibleEC.text = _evaluationController.evaluation!.responsible ?? '';
  }

  @override
  Widget build(BuildContext context) {
    _customerEC.text = _evaluationController.evaluation!.customer?.shortName ?? '';
    _compressorEC.text = _evaluationController.evaluation!.compressor?.compressorName ?? '';
    final String serialNumber = _evaluationController.evaluation!.compressor?.serialNumber ?? '';
    final String sector = _evaluationController.evaluation!.compressor?.sector ?? '';
    final String separator = serialNumber != '' && sector != '' ? '/' : '';
    final String serialNumberAndSector = '$serialNumber$separator$sector';
    _serialNumberEC.text = serialNumberAndSector;

    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _evaluationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: _evaluationController.source == SourceTypes.fromNew,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      CompressorModel? compressor = await CompressorPicker.pick(context: context);
                      if (compressor != null) {
                        var customer = _personController.customers.firstWhere((customer) => customer.compressors.contains(compressor));
                        _evaluationController.updateCustomer(customer);
                        _evaluationController.updateCompressor(compressor);
                      }
                    },
                    child: Text('Buscar Cliente/Compressor'),
                  ),
                ),
              ),
              Form(
                key: widget.formKey,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: _customerEC,
                        readOnly: true,
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: InputDecoration(labelText: 'Cliente'),
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: _compressorEC,
                              validator: Validatorless.required('Campo obrigatório'),
                              decoration: InputDecoration(labelText: 'Compressor'),
                              style: TextStyle(color: theme.colorScheme.primary),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _serialNumberEC,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              decoration: InputDecoration(labelText: 'Nº Série/Setor'),
                              style: TextStyle(color: theme.colorScheme.primary),
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
                              readOnly: _evaluationController.source == SourceTypes.fromSaved,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: Validatorless.required('Campo obrigatório'),
                              decoration: InputDecoration(
                                labelText: 'Horímetro',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _evaluationController.updateHorimeter(int.tryParse(value) ?? 0),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<OilTypes>(
                              alignment: AlignmentDirectional.center,
                              value: _evaluationController.evaluation!.oilType,
                              decoration: InputDecoration(
                                labelText: 'Tipo de Óleo',
                              ),
                              items: OilTypes.values.map((oilType) {
                                return DropdownMenuItem<OilTypes>(
                                  value: oilType,
                                  child: Text(
                                    oilType.stringValue,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                );
                              }).toList(),
                              onChanged: _evaluationController.source != SourceTypes.fromSaved
                                  ? (oilType) {
                                      _evaluationController.updateOilType(oilType!);
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
                              readOnly: _evaluationController.source == SourceTypes.fromSaved,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    _evaluationController.evaluation!.oilType!,
                                    PartTypes.airFilter,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Filtro de Ar',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _evaluationController.updateAirFilter(int.tryParse(value) ?? 0),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _oilFilterEC,
                              readOnly: _evaluationController.source == SourceTypes.fromSaved,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    _evaluationController.evaluation!.oilType!,
                                    PartTypes.oilFilter,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Filtro de Óleo',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _evaluationController.updateOilFilter(int.tryParse(value) ?? 0),
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
                              readOnly: _evaluationController.source == SourceTypes.fromSaved,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    _evaluationController.evaluation!.oilType!,
                                    PartTypes.separator,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Separador',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _evaluationController.updateSeparator(int.tryParse(value) ?? 0),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _oilEC,
                              readOnly: _evaluationController.source == SourceTypes.fromSaved,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*$'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    _evaluationController.evaluation!.oilType!,
                                    PartTypes.oil,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Óleo',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _evaluationController.updateOil(int.tryParse(value) ?? 0),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _adviceEC,
                        readOnly: _evaluationController.source == SourceTypes.fromSaved,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: 'Parecer Técnico'),
                        maxLines: 5,
                        onChanged: (value) => _evaluationController.updateAdvice(value),
                      ),
                      Column(
                        children: [
                          Text(
                            "Necessário orçamento?",
                            style: theme.textTheme.bodyLarge,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: Text("Sim"),
                                  value: true,
                                  groupValue: _evaluationController.evaluation!.needProposal,
                                  onChanged: (bool? value) {
                                    if (_evaluationController.source == SourceTypes.fromSaved) {
                                      null;
                                    } else {
                                      _evaluationController.updateNeedProposal(value!);
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: Text("Não"),
                                  value: false,
                                  groupValue: _evaluationController.evaluation!.needProposal,
                                  onChanged: (bool? value) {
                                    if (_evaluationController.source == SourceTypes.fromSaved) {
                                      null;
                                    } else {
                                      _evaluationController.updateNeedProposal(value!);
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      TextFormField(
                        controller: _responsibleEC,
                        readOnly: _evaluationController.source == SourceTypes.fromSaved,
                        textCapitalization: TextCapitalization.words,
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: InputDecoration(labelText: 'Responsável'),
                        onChanged: (value) => _evaluationController.updateResponsible(value),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
