import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/core/widgets/technician_picker/technician_picker_tile_widget.dart';

class TechnicianPickerListWidget extends StatefulWidget {
  const TechnicianPickerListWidget({
    super.key,
    required this.technicians,
    required this.onTechnicianSelected,
  });
  final List<PersonModel> technicians;

  final ValueChanged<PersonModel> onTechnicianSelected;

  @override
  State<TechnicianPickerListWidget> createState() => _TechnicianChoseListWidgetState();
}

class _TechnicianChoseListWidgetState extends State<TechnicianPickerListWidget> {
  late final DataController personController;

  @override
  void initState() {
    super.initState();
    personController = Locator.get<DataController>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.technicians.length,
      itemBuilder: (context, index) {
        return TechnicianPickerTileWidget(
          technician: widget.technicians[index],
          onTechnicianSelected: widget.onTechnicianSelected,
        );
      },
    );
  }
}
