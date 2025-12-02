import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuantity != _quantity) {
      setState(() {
        _quantity = widget.initialQuantity;
      });
    }
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        widget.onQuantityChanged(_quantity);
      });
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
      widget.onQuantityChanged(_quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão de Decremento (-)
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _quantity > 0 ? _decrement : null,
            color: Theme.of(context).colorScheme.primary,
          ),
          // Texto da Quantidade
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$_quantity',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _increment,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
