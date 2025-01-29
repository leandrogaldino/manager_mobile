import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/pages/evaluation/widgets/expandable_section_widget.dart';
import 'package:manager_mobile/pages/evaluation/widgets/reading_section_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
              ExpandableSectionWidget(
                initiallyExpanded: true,
                title: 'Leitura',
                child: ReadingSectionWidget(
                  evaluation: widget.evaluation,
                  formKey: formKey,
                ),
              ),
              //TODO: Fazer igual o primeiro
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
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text('Técnico ${index + 1}'));
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {},
                      ),
                    )
                  ],
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
              ElevatedButton(
                  key: formKey,
                  onPressed: () {
                    final valid = formKey.currentState?.validate() ?? false;
                    if (valid) {}
                  },
                  child: Text('Salvar'))
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
