import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/technician_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class TechnicianSectionWidget extends StatefulWidget {
  final EvaluationModel evaluation;
  final EvaluationSource source;

  const TechnicianSectionWidget({
    super.key,
    required this.evaluation,
    required this.source,
  });

  @override
  State<TechnicianSectionWidget> createState() => _TechnicianSectionWidgetState();
}

class _TechnicianSectionWidgetState extends State<TechnicianSectionWidget> {
  late final EvaluationController evaluationController;

  @override
  void initState() {
    super.initState();
    evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: evaluationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: evaluationController.source != EvaluationSource.fromSaved,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      PersonModel? technician = await TechnicianPicker.pick(context: context);
                      if (technician != null) evaluationController.addTechnician(EvaluationTechnicianModel(id: 0, isMain: false, technician: technician));
                    },
                    child: Text('Incluir Técnico'),
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.evaluation.technicians.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.evaluation.technicians[index].technician.shortName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Offstage(
                              offstage: index == 0 || widget.source == EvaluationSource.fromSaved,
                              child: IconButton(
                                  onPressed: () {
                                    evaluationController.removeTechnician(widget.evaluation.technicians[index]);
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          )
                        ],
                      ),
                      index != widget.evaluation.technicians.length - 1
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
