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
      // Estilo de borda arredondada (opcional, mas comum no iFood)
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ocupa o mínimo de espaço horizontal
        children: [
          // Botão de Decremento (-)
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _quantity > 0 ? _decrement : null, // Desabilita se for 1
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

          // Botão de Incremento (+)
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
