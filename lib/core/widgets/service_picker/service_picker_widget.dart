import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class ServicePickerWidget extends StatefulWidget {
  const ServicePickerWidget({
    super.key,
    required this.onServiceSelected,
  });
  final ValueChanged<ServiceModel> onServiceSelected;

  @override
  State<ServicePickerWidget> createState() => _ServicePickerWidgetState();
}

class _ServicePickerWidgetState extends State<ServicePickerWidget> {
  late final TextEditingController _serviceEC;
  late final DataService _dataService;
  late List<ServiceModel> filteredServices;

  @override
  void initState() {
    super.initState();
    _serviceEC = TextEditingController();
    _dataService = Locator.get<DataService>();
    filteredServices = _dataService.services;
  }

  @override
  void dispose() {
    _serviceEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _serviceEC,
          decoration: InputDecoration(labelText: 'Serviço'),
          onChanged: (value) {
            setState(() {
              filteredServices = _dataService.services.where((service) {
                return service.name.toLowerCase().contains(value);
              }).toList();
            });
          },
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredServices[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredServices[index].name),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                  onTap: () {
                    widget.onServiceSelected(filteredServices[index]);
                  },
                );
              }),
        )
      ],
    );
  }
}
