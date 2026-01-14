import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/paged_list_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class TechnicianPickerWidget extends StatefulWidget {
  const TechnicianPickerWidget({
    super.key,
    required this.onTechnicianSelected,
  });
  final ValueChanged<PersonModel> onTechnicianSelected;

  @override
  State<TechnicianPickerWidget> createState() => _TechnicianPickerWidgetState();
}

class _TechnicianPickerWidgetState extends State<TechnicianPickerWidget> {
  late final TextEditingController _technicianEC;
  late final PagedListController<PersonModel> _technicians;
  late final PersonService _personService;
  late final ScrollController _scrollController;
  late final EvaluationController _evaluationController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _personService = Locator.get<PersonService>();
    _technicianEC = TextEditingController();
    _scrollController = ScrollController();
    _evaluationController = Locator.get<EvaluationController>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _technicians.loadMore();
      }
    });
    _technicians = PagedListController<PersonModel>((offset, limit) {
      return _personService.searchVisibleTechnicians(
        offset: offset,
        limit: limit,
        search: _searchText,
        remove: _evaluationController.evaluation!.technicians.map((et) => et.technician.id).toList(),
      );
    }, limit: 6);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _technicians.loadInitial();
    });
  }

  @override
  void dispose() {
    _technicianEC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _technicianEC,
          decoration: InputDecoration(labelText: 'Técnico'),
          onChanged: _onTextChanged,
        ),
        Divider(),
        Expanded(
          child: ListenableBuilder(
              listenable: _technicians,
              builder: (context, child) {
                return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _technicians.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_technicians.items[index].shortName),
                            Divider(color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                        onTap: () {
                          widget.onTechnicianSelected(_technicians.items[index]);
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
    _technicians.loadInitial();
  }
}
