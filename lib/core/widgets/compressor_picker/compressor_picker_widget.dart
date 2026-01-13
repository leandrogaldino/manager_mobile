import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/paged_list_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';

class CompressorPickerWidget extends StatefulWidget {
  const CompressorPickerWidget({
    super.key,
    required this.onCompressorSelected,
  });
  final ValueChanged<PersonCompressorModel> onCompressorSelected;

  @override
  State<CompressorPickerWidget> createState() => _CompressorPickerWidgetState();
}

class _CompressorPickerWidgetState extends State<CompressorPickerWidget> {
  late final TextEditingController _customerOrCompressorEC;
  late final PagedListController<PersonCompressorModel> _compressors;
  late final PersonCompressorService _compressorService;
  late final ScrollController _scrollController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _compressorService = Locator.get<PersonCompressorService>();
    _customerOrCompressorEC = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _compressors.loadMore();
      }
    });
    _compressors = PagedListController<PersonCompressorModel>((offset, limit) {
      return _compressorService.searchVisibles(
        offset: offset,
        limit: limit,
        search: _searchText,
      );
    }, limit: 10);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _compressors.loadInitial();
    });
  }

  void _onTextChanged(String value) {
    _searchText = value.trim();

    _compressors.loadInitial();
  }

  @override
  void dispose() {
    _customerOrCompressorEC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _customerOrCompressorEC,
          decoration: InputDecoration(labelText: 'Cliente/Compressor'),
          onChanged: _onTextChanged,
        ),
        Divider(),
        Expanded(
          child: ListenableBuilder(
              listenable: _compressors,
              builder: (context, child) {
                return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _compressors.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_compressors.items[index].compressor.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Offstage(
                              offstage: _compressors.items[index].serialNumber == '',
                              child: Text(_compressors.items[index].serialNumber),
                            ),
                            Text(_compressors.items[index].person.shortName),
                            Offstage(
                              offstage: _compressors.items[index].sector == '',
                              child: Text(_compressors.items[index].sector),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ],
                        ),
                        onTap: () {
                          widget.onCompressorSelected(_compressors.items[index]);
                        },
                      );
                    });
              }),
        )
      ],
    );
  }
}
