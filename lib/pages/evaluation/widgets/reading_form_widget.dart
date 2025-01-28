import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadingFormWidget extends StatefulWidget {
  const ReadingFormWidget({super.key});

  @override
  State<ReadingFormWidget> createState() => _ReadingFormWidgetState();
}

class _ReadingFormWidgetState extends State<ReadingFormWidget> {
  int? selectedItem = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        TextFormField(decoration: InputDecoration(labelText: 'Cliente')),
        TextFormField(decoration: InputDecoration(labelText: 'Compressor')),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Horímetro',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: selectedItem,
                decoration: InputDecoration(labelText: 'Tipo de Óleo'),
                items: [
                  DropdownMenuItem<int>(
                    value: 0, // Valor do item
                    child: Text(
                      'Mineral',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 1, // Valor do item
                    child: Text(
                      'Semi Sintético',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 2, // Valor do item
                    child: Text(
                      'Sintético',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
                onChanged: (item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
              ),
            )
          ],
        ),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Filtro de Ar',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Filtro de Óleo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Separador',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Óleo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Parecer Técnico'),
          maxLines: 5,
        ),
        TextFormField(decoration: InputDecoration(labelText: 'Responsável')),
      ],
    );
  }
}
