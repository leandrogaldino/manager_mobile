import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/technician_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianChoseTileWidget extends StatelessWidget {
  const TechnicianChoseTileWidget({
    super.key,
    required this.technician,
    required this.checked,
  });

  final PersonModel technician;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    final TechnicianController technicianController = Locator.get<TechnicianController>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        trailing: checked ? Icon(Icons.check, color: Colors.white) : null,
        title: Text(
          technician.shortName,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
        ),
        onTap: () async {
          await technicianController.setLoggedTechnicianId(technician.id);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
