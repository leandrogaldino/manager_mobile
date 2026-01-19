import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/service_picker.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/core/widgets/quantity_selector.dart';

class PerformedServiceSectionWidget extends StatefulWidget {
  const PerformedServiceSectionWidget({
    super.key,
    required this.evaluationController,
  });

  final EvaluationController evaluationController;

  @override
  State<PerformedServiceSectionWidget> createState() => _PerformedServiceSectionWidgetState();
}

class _PerformedServiceSectionWidgetState extends State<PerformedServiceSectionWidget> {


  @override
  Widget build(BuildContext context) {
    EvaluationController controller = widget.evaluationController;
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
                  visible: controller.source != SourceTypes.fromSavedWithSign,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      ServiceModel? service = await ServicePicker.pick(context: context);
                      if (service != null) {
                        EvaluationPerformedServiceModel performedService = EvaluationPerformedServiceModel(quantity: 1, service: service);
                        controller.addPerformedService(performedService);
                      }
                    },
                    child: Text('Incluir Serviço'),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.evaluation!.performedServices.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.evaluation!.performedServices[index].service.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          QuantitySelector(
                            readOnly: controller.source == SourceTypes.fromSavedWithSign,
                            initialQuantity: controller.evaluation!.performedServices[index].quantity,
                            onQuantityChanged: (q) async {
                              if (q == 0) {
                                bool? answer = await YesNoPicker.pick(context: context, question: 'Deseja remover este serviço?');
                                if (answer == true) {
                                  controller.removePerformedService(controller.evaluation!.performedServices[index]);
                                } else {
                                  controller.updatePerformedServiceQuantity(index, 1);
                                }
                              } else {
                                controller.updatePerformedServiceQuantity(index, q);
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 1,
                        ),
                      )
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
