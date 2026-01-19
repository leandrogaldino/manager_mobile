import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/helper/Pickers/product_picker.dart';
import 'package:manager_mobile/core/helper/Pickers/yes_no_picker.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/models/evaluation_replaced_product_model.dart';
import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/core/widgets/quantity_selector.dart';

class ReplacedProductSectionWidget extends StatefulWidget {
  const ReplacedProductSectionWidget({
    super.key,
    required this.evaluationController,
  });
  final EvaluationController evaluationController;
  @override
  State<ReplacedProductSectionWidget> createState() => _ReplacedProductSectionWidgetState();
}

class _ReplacedProductSectionWidgetState extends State<ReplacedProductSectionWidget> {
  @override
  Widget build(BuildContext context) {

EvaluationController controller = widget.evaluationController;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: controller.source != SourceTypes.fromSavedWithSign,
                  child: OutlinedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      ProductModel? product = await ProductPicker.pick(context: context);
                      if (product != null) {
                        EvaluationReplacedProductModel replacedProduct = EvaluationReplacedProductModel(quantity: 1, product: product);
                        controller.addReplacedProduct(replacedProduct);
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
                itemCount: controller.evaluation!.replacedProducts.length,
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
                                  controller.evaluation!.replacedProducts[index].product.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  controller.evaluation!.replacedProducts[index].product.codes.map((c) => c.code).join(' • '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          QuantitySelector(
                            readOnly: controller.source == SourceTypes.fromSavedWithSign,
                            initialQuantity: controller.evaluation!.replacedProducts[index].quantity,
                            onQuantityChanged: (q) async {
                              if (q == 0) {
                                bool? answer = await YesNoPicker.pick(context: context, question: 'Deseja remover este produto?');
                                if (answer == true) {
                                  controller.removeReplacedProduct(controller.evaluation!.replacedProducts[index]);
                                } else {
                                  controller.updateReplacedProductQuantity(index, 1);
                                }
                              } else {
                                controller.updateReplacedProductQuantity(index, q);
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
