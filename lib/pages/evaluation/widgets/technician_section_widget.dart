import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';

class TechnicianSectionWidget extends StatelessWidget {
  const TechnicianSectionWidget({super.key, required this.evaluation});
  final EvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: evaluation.technicians.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(evaluation.technicians[index].technician.shortName),
                    ),
                    Offstage(
                      offstage: index == 0,
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    )
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          );
        });
  }
}
