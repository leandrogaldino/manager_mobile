import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/service_picker/service_picker_list_widget.dart';
import 'package:manager_mobile/models/service_model.dart';

class ServicePickerDialog extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicePickerDialog({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
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
        child: ServicePickerListWidget(
          services: services,
          onServiceSelected: (ServiceModel selectedService) {
            Navigator.pop(context, selectedService);
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
