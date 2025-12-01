import 'package:flutter/material.dart';
import 'package:manager_mobile/models/service_model.dart';

class ServicePickerTileWidget extends StatelessWidget {
  const ServicePickerTileWidget({
    super.key,
    required this.service,
    required this.onServiceSelected,
  });

  final ServiceModel service;
  final ValueChanged<ServiceModel> onServiceSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          service.name,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.surface,
              ),
        ),
        onTap: () {
          onServiceSelected(service);
        },
      ),
    );
  }
}
