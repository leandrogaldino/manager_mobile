import 'package:flutter/material.dart';
import 'package:manager_mobile/sync_event.dart';

class SyncEventBus extends ChangeNotifier {
  SyncEvent? _lastEvent;

  SyncEvent? get lastEvent => _lastEvent;

  void emit(SyncEvent event) {
    _lastEvent = event;
    notifyListeners();
  }
}
