import 'package:flutter/material.dart';

class PagedListController<T> extends ChangeNotifier {
  final Future<List<T>> Function(int offset, int limit) loader;
  final int limit;

  final List<T> items = [];
  bool loading = false;
  bool hasMore = true;
  int offset = 0;

  PagedListController(
    this.loader, {
    this.limit = 15,
  });

  bool updateItem(
    bool Function(T item) where,
    T Function(T old) update,
  ) {
    final index = items.indexWhere(where);
    if (index == -1) return false;

    items[index] = update(items[index]);
    notifyListeners();
    return true;
  }

  Future<void> loadInitial() async {
    items.clear();
    offset = 0;
    hasMore = true;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (loading || !hasMore) return;

    loading = true;
    final result = await loader(offset, limit);
    items.addAll(result);
    offset += result.length;
    hasMore = result.length == limit;
    loading = false;
    notifyListeners();
  }

  void removeWhere(bool Function(T item) test) {
    items.removeWhere(test);
    notifyListeners();
  }

  void retainWhere(bool Function(T item) test) {
    items.retainWhere(test);
    notifyListeners();
  }
}
