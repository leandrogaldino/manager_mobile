import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
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
  late final EvaluationController _evaluationController;
  late List<ServiceModel> _filteredServices;

  @override
  void initState() {
    super.initState();
    _serviceEC = TextEditingController();
    _dataService = Locator.get<DataService>();
    _evaluationController = Locator.get<EvaluationController>();

    var services = _evaluationController.evaluation!.performedServices.map((x) => x.service).toList();

    _filteredServices = _dataService.services;
    _filteredServices = _filteredServices.where((x) {
      return !services.any((s) => s.id == x.id);
    }).toList();
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
              _filteredServices = _dataService.services.where((service) {
                return service.name.toLowerCase().contains(value);
              }).toList();
            });
          },
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredServices[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_filteredServices[index].name),
                                               Divider(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                  onTap: () {
                    widget.onServiceSelected(_filteredServices[index]);
                  },
                );
              }),
        )
      ],
    );
  }
}
