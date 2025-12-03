import 'package:flutter/material.dart';
import 'package:manager_mobile/core/widgets/product_picker/product_picker_dialog.dart';
import 'package:manager_mobile/models/product_model.dart';

class ProductPicker {
  static Future<ProductModel?> pick({
    required BuildContext context,
  }) async {
    ProductModel? product;

    if (!context.mounted) return null;
    product = await showDialog<ProductModel>(
      context: context,
      builder: (BuildContext context) {
        return ProductPickerDialog();
      },
    );
    return product;
  }
}
