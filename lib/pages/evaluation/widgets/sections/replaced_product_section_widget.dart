import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/product_picker.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/models/evaluation_replaced_product_model.dart';
import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/core/widgets/quantity_selector.dart';

class ReplacedProductSectionWidget extends StatefulWidget {
  const ReplacedProductSectionWidget({super.key});

  @override
  State<ReplacedProductSectionWidget> createState() => _ReplacedProductSectionWidgetState();
}

class _ReplacedProductSectionWidgetState extends State<ReplacedProductSectionWidget> {
  late final EvaluationController _evaluationController;

  @override
  void initState() {
    super.initState();
    _evaluationController = Locator.get<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _evaluationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: _evaluationController.source != SourceTypes.fromSaved,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      ProductModel? product = await ProductPicker.pick(context: context);
                      if (product != null) {
                        EvaluationReplacedProductModel replacedProduct = EvaluationReplacedProductModel(quantity: 1, product: product);
                        _evaluationController.addReplacedProduct(replacedProduct);
                      }
                    },
                    child: Text('Incluir Produto'),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _evaluationController.evaluation!.replacedProducts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _evaluationController.evaluation!.replacedProducts[index].product.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  _evaluationController.evaluation!.replacedProducts[index].product.codes.map((c) => c.code).join(' • '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          QuantitySelector(
                            initialQuantity: _evaluationController.evaluation!.replacedProducts[index].quantity,
                            onQuantityChanged: (q) async {
                              if (q == 0) {
                                bool? answer = await YesNoPicker.pick(context: context, question: 'Deseja remover este produto?');
                                if (answer == true) {
                                  _evaluationController.removeReplacedProduct(_evaluationController.evaluation!.replacedProducts[index]);
                                } else {
                                  _evaluationController.updateReplacedProductQuantity(index, 1);
                                }
                              } else {
                                _evaluationController.updateReplacedProductQuantity(index, q);
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 1,
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
