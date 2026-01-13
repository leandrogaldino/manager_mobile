import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/technician_picker/technician_picker_dialog.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianPicker {
  static Future<PersonModel?> pick({
    required BuildContext context,
  }) async {
    PersonModel? technician;

    if (!context.mounted) return null;
    technician = await showDialog<PersonModel>(
      context: context,
      builder: (BuildContext context) {
        return TechnicianPickerDialog();
      },
    );
    return technician;
  }
}
