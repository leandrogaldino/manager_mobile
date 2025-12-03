import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/services/data_service.dart';

class ProductPickerWidget extends StatefulWidget {
  const ProductPickerWidget({
    super.key,
    required this.onServiceSelected,
  });
  final ValueChanged<ProductModel> onServiceSelected;

  @override
  State<ProductPickerWidget> createState() => _ProductPickerWidgetState();
}

class _ProductPickerWidgetState extends State<ProductPickerWidget> {
  late final TextEditingController _productEC;
  late final DataService _dataService;
  late final EvaluationController _evaluationController;
  late List<ProductModel> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _productEC = TextEditingController();
    _dataService = Locator.get<DataService>();
    _evaluationController = Locator.get<EvaluationController>();
    var products = _evaluationController.evaluation!.replacedProducts.map((x) => x.product).toList();
    _filteredProducts = _dataService.products;
    _filteredProducts = _filteredProducts.where((x) {
      return !products.any((s) => s.id == x.id);
    }).toList();
  }

  @override
  void dispose() {
    _productEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _productEC,
          decoration: InputDecoration(labelText: 'Produto'),
          onChanged: (value) {
            setState(() {
              _filteredProducts = _dataService.products.where((product) {
                return product.name.toLowerCase().contains(value) || product.codes.any((p) => p.code.contains(value));
              }).toList();
            });
          },
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredProducts[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_filteredProducts[index].codes.map((e) => e.code).toList().join(" • ")),
                      Divider(color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  onTap: () {
                    widget.onServiceSelected(_filteredProducts[index]);
                  },
                );
              }),
        )
      ],
    );
  }
}
