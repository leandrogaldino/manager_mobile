import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/technician_chose/technician_choose_list_widget.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianChooseDialog extends StatelessWidget {
  final List<PersonModel> technicians;
  final int loggedTechnician;

  const TechnicianChooseDialog({
    super.key,
    required this.technicians,
    required this.loggedTechnician,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Escolha o Técnico')),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: TechnicianChoseListWidget(
          technicians: technicians,
          loggedTechnician: loggedTechnician,
        ),
      ),
    );
  }
}
