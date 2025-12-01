import 'package:flutter/material.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/widgets/service_picker/service_picker_tile_widget.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class ServicePickerListWidget extends StatefulWidget {
  const ServicePickerListWidget({
    super.key,
    required this.services,
    required this.onServiceSelected,
  });
  final List<ServiceModel> services;

  final ValueChanged<ServiceModel> onServiceSelected;

  @override
  State<ServicePickerListWidget> createState() => _ServicePickerListWidgetState();
}

class _ServicePickerListWidgetState extends State<ServicePickerListWidget> {
  late final DataService dataService;

  @override
  void initState() {
    super.initState();
    dataService = Locator.get<DataService>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.services.length,
      itemBuilder: (context, index) {
        return ServicePickerTileWidget(
          service: widget.services[index],
          onServiceSelected: widget.onServiceSelected,
        );
      },
    );
  }
}
