import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/technician_picker.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';

class TechnicianSectionWidget extends StatefulWidget {
  const TechnicianSectionWidget({super.key, required this.evaluationController,});

  final EvaluationController evaluationController;


  @override
  State<TechnicianSectionWidget> createState() => _TechnicianSectionWidgetState();
}

class _TechnicianSectionWidgetState extends State<TechnicianSectionWidget> {
   
  @override
  Widget build(BuildContext context) {
    final EvaluationController controller = widget.evaluationController;
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
                      PersonModel? technician = await TechnicianPicker.pick(context: context);
                      if (technician != null) controller.addTechnician(EvaluationTechnicianModel(isMain: false, technician: technician));
                    },
                    child: Text('Incluir Técnico'),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.evaluation!.technicians.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.evaluation!.technicians[index].technician.shortName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Offstage(
                              offstage: index == 0 || controller.source == SourceTypes.fromSavedWithSign,
                              child: IconButton(
                                  onPressed: () {
                                    controller.removeTechnician(controller.evaluation!.technicians[index]);
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        height: 1,
                      ),
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
