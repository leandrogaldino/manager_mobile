import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/technician_picker/technician_picker_dialog.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianPicker {
  static Future<PersonModel?> pick({
    required BuildContext context,
    List<PersonModel>? hide,
  }) async {
    DataController personController = Locator.get<DataController>();
    EvaluationController evaluationController = Locator.get<EvaluationController>();
    PersonModel? person;

    var allTechnicians = personController.technicians;
    var evaluationTechnicians = evaluationController.evaluation!.technicians.map((person) => person.technician).toList();

    allTechnicians = allTechnicians.where((technician) {
      return !evaluationTechnicians.any((evaluation) => evaluation.id == technician.id);
    }).toList();

    if (hide != null) {
      for (var person in hide) {
        allTechnicians.remove(person);
      }
    }

    if (!context.mounted) return null;
    person = await showDialog<PersonModel>(
      context: context,
      builder: (BuildContext context) {
        return TechniciaPickerDialog(
          technicians: allTechnicians,
        );
      },
    );

    return person;
  }
}
