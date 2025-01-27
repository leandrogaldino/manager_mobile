import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_mobile/models/evaluation_model.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key, required this.evaluation});

  final EvaluationModel evaluation;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  bool isFormExpanded = false;
  bool isCoalescentExpanded = false;
  bool isTechnicianExpanded = false;
  bool isPhotoExpanded = false;
  bool isSignatureExpanded = false;
  TimeOfDay selectedTime = TimeOfDay.now();

  int? selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildExpandableSection(
                title: 'Leitura',
                isExpanded: isFormExpanded,
                onTap: () {
                  setState(() {
                    isFormExpanded = !isFormExpanded;
                  });
                },
                child: Column(
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
                ),
              ),
              _buildExpandableSection(
                title: 'Coalescentes',
                isExpanded: isCoalescentExpanded,
                onTap: () {
                  setState(() {
                    isCoalescentExpanded = !isCoalescentExpanded;
                  });
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text('Coalescente ${index + 1}'));
                  },
                ),
              ),
              _buildExpandableSection(
                title: 'Técnicos',
                isExpanded: isTechnicianExpanded,
                onTap: () {
                  setState(() {
                    isTechnicianExpanded = !isTechnicianExpanded;
                  });
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text('Técnico ${index + 1}'));
                  },
                ),
              ),
              _buildExpandableSection(
                title: 'Fotos',
                isExpanded: isPhotoExpanded,
                onTap: () {
                  setState(() {
                    isPhotoExpanded = !isPhotoExpanded;
                  });
                },
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.camera_alt, size: 50),
                  ),
                ),
              ),
              _buildExpandableSection(
                title: 'Assinatura',
                isExpanded: isSignatureExpanded,
                onTap: () {
                  setState(() {
                    isSignatureExpanded = !isSignatureExpanded;
                  });
                },
                child: GestureDetector(
                  onPanUpdate: (details) {},
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(child: Text('Desenhe sua assinatura aqui')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection({required String title, required bool isExpanded, required VoidCallback onTap, required Widget child}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300), // Ajuste o tempo da animação
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onTap: onTap,
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300), // Ajuste o tempo da animação do tamanho
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: child,
                  )
                : SizedBox.shrink(), // Quando não expandido, não ocupa espaço
          ),
        ],
      ),
    );
  }
}
