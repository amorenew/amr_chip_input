import 'package:flutter/material.dart';

class ChipsInputController extends ValueNotifier<List<String>> {
  ChipsInputController({required List<String> initialChips})
      : super(initialChips);

  String lastQuery = '';

  void update({required List<String> chips}) {
    value = chips;
    notifyListeners();
  }

  List<String> get chips => <String>[
        ...value.where((String e) => e.trim() != lastQuery.trim()),
        if (lastQuery.trim().isNotEmpty) lastQuery,
      ];
}
