import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/service_picker/service_picker_dialog.dart';
import 'package:manager_mobile/models/service_model.dart';

class ServicePicker {
  static Future<ServiceModel?> pick({
    required BuildContext context,
  }) async {
    ServiceModel? service;

    if (!context.mounted) return null;
    service = await showDialog<ServiceModel>(
      context: context,
      builder: (BuildContext context) {
        return ServicePickerDialog();
      },
    );
    return service;
  }
}
