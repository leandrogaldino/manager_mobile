import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/person_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/core/widgets/technician_choose/technician_chose_tile_widget.dart';

class TechnicianChooseListWidget extends StatefulWidget {
  const TechnicianChooseListWidget({
    super.key,
    required this.technicians,
    required this.onTechnicianSelected,
  });
  final List<PersonModel> technicians;

  final ValueChanged<PersonModel> onTechnicianSelected;

  @override
  State<TechnicianChooseListWidget> createState() => _TechnicianChoseListWidgetState();
}

class _TechnicianChoseListWidgetState extends State<TechnicianChooseListWidget> {
  late final PersonController personController;

  @override
  void initState() {
    super.initState();
    personController = Locator.get<PersonController>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.technicians.length,
      itemBuilder: (context, index) {
        return TechnicianChoseTileWidget(
          technician: widget.technicians[index],
          onTechnicianSelected: widget.onTechnicianSelected,
        );
      },
    );
  }
}
