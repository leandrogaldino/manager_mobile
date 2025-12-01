import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/service_picker/service_picker_dialog.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class ServicePicker {
  static Future<ServiceModel?> pick({
    required BuildContext context,
  }) async {
    DataService dataController = Locator.get<DataService>();    
    ServiceModel? service;
    var allServices = dataController.services;
    if (!context.mounted) return null;
    service = await showDialog<ServiceModel>(
      context: context,
      builder: (BuildContext context) {
        return ServicePickerDialog(
          services: allServices,
        );
      },
    );
    return service;
  }
}
