import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/technician_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class TechnicianSectionWidget extends StatefulWidget {
  const TechnicianSectionWidget({super.key});

  @override
  State<TechnicianSectionWidget> createState() => _TechnicianSectionWidgetState();
}

class _TechnicianSectionWidgetState extends State<TechnicianSectionWidget> {
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
                  visible: _evaluationController.source != EvaluationSource.fromSaved,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      PersonModel? technician = await TechnicianPicker.pick(context: context);
                      if (technician != null) _evaluationController.addTechnician(EvaluationTechnicianModel(id: 0, isMain: false, technician: technician));
                    },
                    child: Text('Incluir Técnico'),
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _evaluationController.evaluation!.technicians.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _evaluationController.evaluation!.technicians[index].technician.shortName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Offstage(
                              offstage: index == 0 || _evaluationController.source == EvaluationSource.fromSaved,
                              child: IconButton(
                                  onPressed: () {
                                    _evaluationController.removeTechnician(_evaluationController.evaluation!.technicians[index]);
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
