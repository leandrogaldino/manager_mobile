import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/paged_list_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/services/data_service.dart';
import 'package:manager_mobile/services/service_service.dart';

class ServicePickerWidget extends StatefulWidget {
  const ServicePickerWidget({
    super.key,
    required this.onServiceSelected,
  });
  final ValueChanged<ServiceModel> onServiceSelected;

  @override
  State<ServicePickerWidget> createState() => _ServicePickerWidgetState();
}

class _ServicePickerWidgetState extends State<ServicePickerWidget> {
  late final TextEditingController _serviceEC;
  late final PagedListController<ServiceModel> _services;
  late final ServiceService _serviceService;
  late final ScrollController _scrollController;
  late final EvaluationController _evaluationController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _serviceService = Locator.get<ServiceService>();
    _serviceEC = TextEditingController();
    _scrollController = ScrollController();
    _evaluationController = Locator.get<EvaluationController>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _services.loadMore();
      }
    });
    _services = PagedListController<ServiceModel>((offset, limit) {
      return _serviceService.searchVisibles(
        offset: offset,
        limit: limit,
        search: _searchText,
        remove: _evaluationController.evaluation!.performedServices.map((et) => et.service.id).toList(),
      );
    }, limit: 6);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _services.loadInitial();
    });
  }

  @override
  void dispose() {
    _serviceEC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _serviceEC,
          decoration: InputDecoration(labelText: 'Serviço'),
          onChanged: _onTextChanged,
        ),
        Divider(),
        Expanded(
          child: ListenableBuilder(
              listenable: _services,
              builder: (context, child) {
                return ListView.builder(
                    itemCount: _services.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_services.items[index].name),
                            Divider(color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                        onTap: () {
                          widget.onServiceSelected(_services.items[index]);
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
    _services.loadInitial();
  }
}
