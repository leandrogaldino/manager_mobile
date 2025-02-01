import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/technician_chose/technician_chose_dialog.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';

class TechnicianPicker {
  static Future<PersonModel?> ensureLoggedTechnician({
    required BuildContext context,
  }) async {
    AppPreferences appPreferences = Locator.get<AppPreferences>();
    TechnicianController technicianController = Locator.get<TechnicianController>();
    var loggedId = await appPreferences.getLoggedTechnicianId;
    PersonModel? person;
    if (loggedId == 0) {
      var technicians = await technicianController.getTechnicians();
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
    }
    return person;
  }
}
