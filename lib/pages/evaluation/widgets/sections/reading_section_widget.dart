import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/core/helper/Pickers/compressor_picker.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/core/enums/part_types.dart';
import 'package:manager_mobile/pages/evaluation/validation/double_input_formatter.dart';
import 'package:manager_mobile/pages/evaluation/validation/evaluation_validators.dart';
import 'package:validatorless/validatorless.dart';

class ReadingSectionWidget extends StatefulWidget {
  const ReadingSectionWidget({
    super.key,
    required this.formKey,
    required this.evaluationController,
  });

  final EvaluationController evaluationController;

  final GlobalKey<FormState> formKey;

  @override
  State<ReadingSectionWidget> createState() => _ReadingSectionWidgetState();
}

class _ReadingSectionWidgetState extends State<ReadingSectionWidget> {
  late final TextEditingController _customerEC;
  late final TextEditingController _compressorEC;
  late final TextEditingController _interfaceEC;
  late final TextEditingController _unitEC;
  late final TextEditingController _temperatureEC;
  late final TextEditingController _pressureEC;
  late final TextEditingController _oilTypeEC;
  late final TextEditingController _horimeterEC;
  late final TextEditingController _greasingEC;
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
    _interfaceEC.dispose();
    _unitEC.dispose();
    _temperatureEC.dispose();
    _pressureEC.dispose();
    _oilTypeEC.dispose();
    _horimeterEC.dispose();
    _greasingEC.dispose();
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
    _customerEC = TextEditingController();
    _customerEC.addListener(() {
      if (widget.evaluationController.evaluation!.compressor != null && (_customerEC.text != widget.evaluationController.evaluation!.compressor!.person.shortName)) {
        widget.evaluationController.updateCompressor(null);
        _compressorEC.text = '';
      }
    });
    _compressorEC = TextEditingController();
    _compressorEC.addListener(() {
      if (widget.evaluationController.evaluation!.compressor != null && _compressorEC.text != _compressorFullName) {
        widget.evaluationController.updateCompressor(null);
      }
    });
    _interfaceEC = TextEditingController();
    _unitEC = TextEditingController();
    _temperatureEC = TextEditingController();
    _pressureEC = TextEditingController();
    _oilTypeEC = TextEditingController();
    _horimeterEC = TextEditingController();
    _greasingEC = TextEditingController();
    _airFilterEC = TextEditingController();
    _oilFilterEC = TextEditingController();
    _separatorEC = TextEditingController();
    _oilEC = TextEditingController();
    _adviceEC = TextEditingController();
    _responsibleEC = TextEditingController();
    _adviceFocusNode = FocusNode();
    _syncControllers();
  }

  void _setText(TextEditingController controller, String value) {
    if (controller.text == value) return;

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  void _syncControllers() {
    final controller = widget.evaluationController;
    final evaluation = controller.evaluation!;
    final compressor = evaluation.compressor;
    final fromSaved = controller.source == SourceTypes.fromSavedWithSign;

    _setText(_customerEC, compressor?.person.shortName ?? '');
    _setText(_compressorEC, _compressorFullName);
    _setText(_interfaceEC, compressor?.interface.name ?? '');
    _setText(_unitEC, compressor?.unit.name ?? '');
    _setText(_oilTypeEC, fromSaved ? evaluation.oilType.stringValue : compressor?.oilType.stringValue ?? '');
    _setText(_temperatureEC, evaluation.temperature?.toString() ?? '');

    _setText(_pressureEC, evaluation.pressure?.toString().replaceAll('.', ',') ?? '');

    _setText(_horimeterEC, evaluation.horimeter?.toString() ?? '');
    if (fromSaved) {
      _setText(_greasingEC, evaluation.greasing?.toString() ?? 'N/A');
    } else {
      if (compressor?.greasingCapacity != null) {
        _setText(_greasingEC, evaluation.greasing?.toString() ?? '');
      } else {
        _setText(_greasingEC, compressor == null ? '' : 'N/A');
      }
    }
    _setText(_airFilterEC, evaluation.airFilter?.toString() ?? '');
    _setText(_oilFilterEC, evaluation.oilFilter?.toString() ?? '');
    _setText(_separatorEC, evaluation.separator?.toString() ?? '');
    _setText(_oilEC, evaluation.oil?.toString() ?? '');
    _setText(_adviceEC, evaluation.advice ?? '');
    _setText(_responsibleEC, evaluation.responsible ?? '');
  }

  String get _compressorFullName {
    String compressorFullName = widget.evaluationController.evaluation!.compressor?.compressor.name ?? '';
    final String serialNumber = widget.evaluationController.evaluation!.compressor?.serialNumber ?? '';
    final String patrimony = widget.evaluationController.evaluation!.compressor?.patrimony ?? '';
    final String sector = widget.evaluationController.evaluation!.compressor?.sector ?? '';
    compressorFullName += serialNumber.isNotEmpty ? ' NS: $serialNumber' : '';
    compressorFullName += patrimony.isNotEmpty ? ' PAT: $patrimony' : '';
    compressorFullName += sector.isNotEmpty ? ' - $sector' : '';
    return compressorFullName;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.evaluationController;
    final evaluation = controller.evaluation!;
    final compressor = evaluation.compressor;
    final fromSaved = controller.source == SourceTypes.fromSavedWithSign;
    final greasable = fromSaved ? evaluation.greasing != null : compressor?.greasingCapacity != null;

    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: controller.source == SourceTypes.fromNew,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      PersonCompressorModel? compressor = await CompressorPicker.pick(context: context);
                      if (compressor != null) {
                        controller.updateCompressor(compressor);
                        _syncControllers();
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
                      TextFormField(
                        readOnly: true,
                        controller: _compressorEC,
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: InputDecoration(labelText: 'Compressor'),
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _interfaceEC,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                    return newValue.copyWith(
                                      text: newValue.text.toUpperCase(),
                                      selection: newValue.selection,
                                    );
                                  },
                                ),
                                // Permite somente A-Z e 0-9
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Z0-9]'),
                                ),
                              ],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                ],
                              ),
                              decoration: const InputDecoration(labelText: 'Interface', border: OutlineInputBorder()),
                              style: TextStyle(color: theme.colorScheme.primary),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _unitEC,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                    return newValue.copyWith(
                                      text: newValue.text.toUpperCase(),
                                      selection: newValue.selection,
                                    );
                                  },
                                ),
                                // Permite somente A-Z e 0-9
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Z0-9]'),
                                ),
                              ],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Unidade',
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: theme.colorScheme.primary),
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
                              controller: _temperatureEC,
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Temperatura (ºC)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => controller.updateTemperature(int.tryParse(value) ?? 0),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _pressureEC,
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [DoubleInputFormatter()],
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                              ]),
                              decoration: const InputDecoration(
                                labelText: 'Pressão (BAR)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  controller.updatePresure(null);
                                  return;
                                }
                                final normalized = value.replaceAll(',', '.');
                                final parsed = double.tryParse(normalized);
                                if (parsed == null) return;
                                controller.updatePresure(parsed);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<CallTypes>(
                              alignment: AlignmentDirectional.center,
                              initialValue: controller.evaluation!.callType,
                              decoration: InputDecoration(
                                labelText: 'Tipo de Visita',
                              ),
                              items: CallTypes.values.map((callType) {
                                return DropdownMenuItem<CallTypes>(
                                  value: callType,
                                  child: Text(
                                    callType.stringValue,
                                    style: theme.textTheme.bodyLarge!.copyWith(color: controller.source == SourceTypes.fromNew ? theme.colorScheme.onSurface : theme.colorScheme.primary),
                                  ),
                                );
                              }).toList(),
                              onChanged: controller.source == SourceTypes.fromNew
                                  ? (callType) {
                                      controller.updateCallType(callType!);
                                    }
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _oilTypeEC,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(labelText: 'Tipo de Óleo', border: OutlineInputBorder()),
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
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: Validatorless.required('Campo obrigatório'),
                              decoration: InputDecoration(
                                labelText: 'Horímetro',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                controller.updateHorimeter(int.tryParse(value) ?? 0);
                              },
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                                controller: _greasingEC,
                                readOnly: controller.evaluation!.compressor?.greasingCapacity == null || controller.source == SourceTypes.fromSavedWithSign,
                                textAlign: TextAlign.center,
                                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
                                validator: (value) {
                                  return Validatorless.multiple([
                                    Validatorless.required('Campo obrigatório'),
                                    EvaluationValidators.validPartTimeRange(
                                      controller.evaluation!.compressor,
                                      PartTypes.greasing,
                                    ),
                                  ])(value);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Engraxamento',
                                ),
                                style: greasable ? TextStyle(color: theme.colorScheme.onSurface) : TextStyle(color: theme.colorScheme.primary),
                                onChanged: (value) {
                                  if (value == '-') return;
                                  controller.updateGreasing(value.isEmpty ? null : int.tryParse(value));
                                }),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _airFilterEC,
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    controller.evaluation!.compressor,
                                    PartTypes.airFilter,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Filtro de Ar',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty || value == '-') return;
                                controller.updateAirFilter(int.tryParse(value) ?? 0);
                              },
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _oilFilterEC,
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    controller.evaluation!.compressor,
                                    PartTypes.oilFilter,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Filtro de Óleo',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty || value == '-') return;
                                controller.updateOilFilter(int.tryParse(value) ?? 0);
                              },
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
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    controller.evaluation!.compressor,
                                    PartTypes.separator,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Separador',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty || value == '-') return;
                                controller.updateSeparator(int.tryParse(value) ?? 0);
                              },
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _oilEC,
                              readOnly: controller.source == SourceTypes.fromSavedWithSign,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required('Campo obrigatório'),
                                  EvaluationValidators.validPartTimeRange(
                                    controller.evaluation!.compressor,
                                    PartTypes.oil,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Óleo',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty || value == '-') return;
                                controller.updateOil(int.tryParse(value) ?? 0);
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _adviceEC,
                        focusNode: _adviceFocusNode,
                        readOnly: controller.source == SourceTypes.fromSavedWithSign,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              return newValue.copyWith(
                                text: newValue.text.toUpperCase(), // transforma tudo
                                selection: newValue.selection,
                              );
                            },
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Parecer Técnico',
                        ),
                        maxLines: 5,
                        onChanged: (value) => controller.updateAdvice(value),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: SwitchListTile(
                          title: Text("Necessário orçamento?"),
                          value: controller.evaluation!.needProposal,
                          onChanged: (bool value) {
                            if (controller.source == SourceTypes.fromSavedWithSign) return;
                            controller.updateNeedProposal(value);
                          },
                        ),
                      ),
                      TextFormField(
                        controller: _responsibleEC,
                        readOnly: controller.source == SourceTypes.fromSavedWithSign,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              return newValue.copyWith(
                                text: newValue.text.toUpperCase(),
                                selection: newValue.selection,
                              );
                            },
                          ),
                          // Permite somente A-Z e 0-9
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z\s]')), // Só permite A-Z e espaços
                        ],
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: InputDecoration(labelText: 'Responsável'),
                        onChanged: (value) => controller.updateResponsible(value),
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
