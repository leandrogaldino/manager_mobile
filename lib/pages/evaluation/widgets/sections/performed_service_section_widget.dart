import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/service_picker.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/core/widgets/quantity_selector.dart';

class PerformedServiceSectionWidget extends StatefulWidget {
  const PerformedServiceSectionWidget({super.key});

  @override
  State<PerformedServiceSectionWidget> createState() => _PerformedServiceSectionWidgetState();
}

class _PerformedServiceSectionWidgetState extends State<PerformedServiceSectionWidget> {
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
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
                  visible: _evaluationController.source != SourceTypes.fromSaved,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      ServiceModel? service = await ServicePicker.pick(context: context);
                      if (service != null) {
                        EvaluationPerformedServiceModel performedService = EvaluationPerformedServiceModel(quantity: 1, service: service);
                        _evaluationController.addPerformedService(performedService);
                      }
                    },
                    child: Text('Incluir Serviço'),
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _evaluationController.evaluation!.performedServices.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  _evaluationController.evaluation!.performedServices[index].service.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                          QuantitySelector(
                            initialQuantity: _evaluationController.evaluation!.performedServices[index].quantity,
                            onQuantityChanged: (q) async {
                              if (q == 0) {
                                bool? answer = await YesNoPicker.pick(context: context, question: 'Deseja remover este serviço?');
                                if (answer == true) {
                                  _evaluationController.removePerformedServiceAt(index);
                                } else {
                                              _evaluationController.updatePerformedServiceQuantity(index, 1);
                                }
                              } else {
                                _evaluationController.updatePerformedServiceQuantity(index, q);
                              }
                            },
                          ),
                        ],
                      ),
                      index != _evaluationController.evaluation!.technicians.length - 1
                          ? Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 1,
                            )
                          : SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
