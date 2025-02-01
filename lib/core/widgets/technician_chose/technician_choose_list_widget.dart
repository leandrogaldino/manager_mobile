import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/core/widgets/technician_chose/technician_chose_tile_widget.dart';

class TechnicianChoseListWidget extends StatelessWidget {
  const TechnicianChoseListWidget({
    super.key,
    required this.technicians,
    required this.loggedTechnician,
    required this.onTechnicianSelected,
  });
  final List<PersonModel> technicians;
  final int loggedTechnician;
  final ValueChanged<PersonModel> onTechnicianSelected;

  @override
  Widget build(BuildContext context) {
    final TechnicianController technicianController = Locator.get<TechnicianController>();
    return ListenableBuilder(
        listenable: technicianController,
        builder: (context, child) {
          return ListView.builder(
            itemCount: technicians.length,
            itemBuilder: (context, index) {
              return TechnicianChoseTileWidget(
                technician: technicians[index],
                checked: loggedTechnician == technicians[index].id,
                onTechnicianSelected: onTechnicianSelected,
              );
            },
          );
        });
  }
}
