import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/technician_chose/technician_chose_dialog.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';

class TechnicianPicker {
  static Future<PersonModel?> pick({
    required BuildContext context,
    List<PersonModel>? hide,
  }) async {
    TechnicianController technicianController = Locator.get<TechnicianController>();
    PersonModel? person;

    var technicians = await technicianController.getTechnicians();

    if (hide != null) {
      for (var person in hide) {
        technicians.remove(person);
      }
    }

    if (!context.mounted) return null;
    person = await showDialog<PersonModel>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TechnicianChooseDialog(
          technicians: technicians,
          loggedTechnician: technicianController.loggedTechnicianId,
        );
      },
    );

    return person;
  }
}
