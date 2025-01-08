import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Locator.get<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Cliente/Compressor",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          ListenableBuilder(
              listenable: homeController,
              builder: (context, child) {
                return TextField(
                  controller: TextEditingController(text: homeController.selectedDateRangeText),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Data",
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange: homeController.selectedDateRange,
                    );

                    homeController.setSelectedDateRange(picked);
                  },
                );
              }),
          Divider()
        ],
      ),
    );
  }
}
