import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/service_picker/service_picker_widget.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class ServicePickerDialog extends StatelessWidget {
  const ServicePickerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DataService dataService = Locator.get<DataService>();
    List<ServiceModel> services = dataService.services;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          'Escolha o Serviço',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: (services.length > 5) ? 330 : (services.length * 66),
        child: ServicePickerWidget(
          onServiceSelected: (service) {
            Navigator.pop(context, service);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(
            'Cancelar',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
