import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/compressor_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/core/enums/part_types.dart';
import 'package:manager_mobile/pages/evaluation/validation/evaluation_validators.dart';
import 'package:manager_mobile/pages/evaluation/widgets/voice_button.dart';
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
  late final FocusNode _adviceFocusNode;

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
    _adviceFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
    _customerEC = TextEditingController();
    _customerEC.addListener(() {
      if (_evaluationController.evaluation!.personCompressor != null && (_customerEC.text != _evaluationController.evaluation!.personCompressor!.person.shortName)) {
        _evaluationController.updateCompressor(null);
        _compressorEC.text = '';
        _serialNumberEC.text = '';
      }
    });
    _compressorEC = TextEditingController();
    _compressorEC.addListener(() {
      if (_evaluationController.evaluation!.personCompressor != null && _compressorEC.text != _evaluationController.evaluation!.personCompressor!.compressor.name) {
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
    _adviceFocusNode = FocusNode();
    _adviceFocusNode.addListener(() {
      setState(() {}); // Atualiza o estado pra mostrar/ocultar o botão
    });
    if (_evaluationController.source != SourceTypes.fromNew) _fillForm();
  }

  void _fillForm() {
    _customerEC.text = _evaluationController.evaluation!.personCompressor!.person.shortName;
    _compressorEC.text = _evaluationController.evaluation!.personCompressor!.compressor.name;
    _serialNumberEC.text = _evaluationController.evaluation!.personCompressor!.serialNumber;
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
    _customerEC.text = _evaluationController.evaluation!.personCompressor?.person.shortName ?? '';
    _compressorEC.text = _evaluationController.evaluation!.personCompressor?.compressor.name ?? '';
    final String serialNumber = _evaluationController.evaluation!.personCompressor?.serialNumber ?? '';
    final String sector = _evaluationController.evaluation!.personCompressor?.sector ?? '';
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
                      PersonCompressorModel? compressor = await CompressorPicker.pick(context: context);
                      if (compressor != null) {
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
                              initialValue: _evaluationController.evaluation!.oilType,
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
                        focusNode: _adviceFocusNode,
                        readOnly: _evaluationController.source == SourceTypes.fromSaved,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z\s]')), // Só permite A-Z e espaços
                        ],
                        decoration: InputDecoration(
                          labelText: 'Parecer Técnico',
                          suffixIcon: _adviceFocusNode.hasFocus
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: VoiceButton(
                                      onListeningEnd: (value) {
                                        if (value == null || value.isEmpty) return;
                                        int currentPosition = _adviceEC.selection.end;
                                        int finalPosition = _adviceEC.text.length;
                                        String text = _adviceEC.text;
                                        text = '${_adviceEC.text.substring(0, currentPosition)}$value';
                                        int selectionPos = text.length;
                                        if (_adviceEC.text.isNotEmpty) {
                                          text = '$text${_adviceEC.text.substring(currentPosition, finalPosition)}';
                                        }
                                        text = text.toUpperCase();
                                        _adviceEC.text = text;
                                        _adviceEC.selection = TextSelection.fromPosition(TextPosition(offset: selectionPos));
                                      },
                                    ),
                                  ),
                                )
                              : null,
                        ),
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
                                  child: RadioGroup(
                                groupValue: _evaluationController.evaluation!.needProposal,
                                onChanged: (bool? value) {
                                  if (_evaluationController.source == SourceTypes.fromSaved) {
                                    null;
                                  } else {
                                    _evaluationController.updateNeedProposal(value!);
                                  }
                                },
                                child: Column(
                                  children: [
                                    RadioListTile<bool>(title: Text("Sim"), value: true),
                                    RadioListTile<bool>(title: Text("Não"), value: false),
                                  ],
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                      TextFormField(
                        controller: _responsibleEC,
                        readOnly: _evaluationController.source == SourceTypes.fromSaved,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z\s]')), // Só permite A-Z e espaços
                        ],
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
