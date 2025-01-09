import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final homeController = Locator.get<HomeController>();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    customerController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListenableBuilder(
        listenable: homeController,
        builder: (context, child) {
          dateController.text = homeController.selectedDateRangeText;
          return Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    customerController.clear();
                    dateController.clear();
                    homeController.setCustomerOrCompressorText('');
                    homeController.setSelectedDateRange(null);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: homeController.filtering
                      ? Text(
                          'Limpar Filtro',
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      : Text(''),
                ),
              ),
              TextField(
                controller: customerController,
                onChanged: (text) {
                  homeController.setCustomerOrCompressorText(text);
                },
                decoration: InputDecoration(
                  labelText: "Cliente/Compressor",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: dateController,
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
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
