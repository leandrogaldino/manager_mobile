import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/service_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/models/service_model.dart';

class ServiceSectionWidget extends StatefulWidget {
  const ServiceSectionWidget({super.key});

  @override
  State<ServiceSectionWidget> createState() => _ServiceSectionWidgetState();
}

class _ServiceSectionWidgetState extends State<ServiceSectionWidget> {
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _evaluationController.evaluation!.performedServices[index].service.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Offstage(
                              offstage: index == 0 || _evaluationController.source == SourceTypes.fromSaved,
                              child: IconButton(
                                  onPressed: () {
                                    _evaluationController.removePerformedService(_evaluationController.evaluation!.performedServices[index]);
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          )
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
