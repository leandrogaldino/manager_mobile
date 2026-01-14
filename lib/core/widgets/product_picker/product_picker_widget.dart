import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/paged_list_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/services/product_service.dart';

class ProductPickerWidget extends StatefulWidget {
  const ProductPickerWidget({
    super.key,
    required this.onProductSelected,
  });
  final ValueChanged<ProductModel> onProductSelected;

  @override
  State<ProductPickerWidget> createState() => _ProductPickerWidgetState();
}

class _ProductPickerWidgetState extends State<ProductPickerWidget> {
  late final TextEditingController _productEC;
  late final PagedListController<ProductModel> _products;
  late final ProductService _productService;
  late final ScrollController _scrollController;
  late final EvaluationController _evaluationController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _productService = Locator.get<ProductService>();
    _productEC = TextEditingController();
    _scrollController = ScrollController();
    _evaluationController = Locator.get<EvaluationController>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _products.loadMore();
      }
    });
    _products = PagedListController<ProductModel>((offset, limit) {
      return _productService.searchVisibles(
        offset: offset,
        limit: limit,
        search: _searchText,
        remove: _evaluationController.evaluation!.replacedProducts.map((et) => et.product.id).toList(),
      );
    }, limit: 6);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _products.loadInitial();
    });
  }

  @override
  void dispose() {
    _productEC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _productEC,
          decoration: InputDecoration(labelText: 'Produto'),
          onChanged: _onTextChanged,
        ),
        Divider(),
        Expanded(
          child: ListenableBuilder(
              listenable: _products,
              builder: (context, child) {
                return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _products.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_products.items[index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_products.items[index].codes.map((e) => e.code).toList().join(" • ")),
                            Divider(color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                        onTap: ()  {
                          widget.onProductSelected(_products.items[index]);
                        },
                      );
                    });
              }),
        )
      ],
    );
  }

  void _onTextChanged(String value) {
    _searchText = value.trim();
    _products.loadInitial();
  }
}
