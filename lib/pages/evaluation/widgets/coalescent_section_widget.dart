import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';

class CoalescentSectionWidget extends StatefulWidget {
  final EvaluationModel evaluation;
  final EvaluationSource source;

  const CoalescentSectionWidget({
    super.key,
    required this.evaluation,
    required this.source,
  });

  @override
  State<CoalescentSectionWidget> createState() => _CoalescentSectionWidgetState();
}

class _CoalescentSectionWidgetState extends State<CoalescentSectionWidget> {
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
                                offstage: index == 0 || widget.source != EvaluationSource.fromNew,
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
