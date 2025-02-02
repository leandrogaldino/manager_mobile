import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';

//TODO: quando a avaliação está salva nao pode aparecer a lixeira
class TechnicianSectionWidget extends StatefulWidget {
  const TechnicianSectionWidget({super.key, required this.evaluation});
  final EvaluationModel evaluation;

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
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
            ),
            child: Scrollbar(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.evaluation.technicians.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.evaluation.technicians[index].technician.shortName),
                              ),
                              Offstage(
                                offstage: index == 0,
                                child: IconButton(
                                    onPressed: () {
                                      evaluationController.removeTechnician(widget.evaluation.technicians[index]);
                                    },
                                    icon: Icon(Icons.delete)),
                              )
                            ],
                          ),
                          Divider(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
