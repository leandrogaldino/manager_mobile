import 'package:flutter/material.dart';
import 'package:manager_mobile/models/person_model.dart';

class TechnicianChoseTileWidget extends StatelessWidget {
  const TechnicianChoseTileWidget({
    super.key,
    required this.technician,
    required this.checked,
    required this.onTechnicianSelected,
  });

  final PersonModel technician;
  final bool checked;
  final ValueChanged<PersonModel> onTechnicianSelected;

  @override
  Widget build(BuildContext context) {
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
        onTap: () {
          onTechnicianSelected(technician);
        },
      ),
    );
  }
}
