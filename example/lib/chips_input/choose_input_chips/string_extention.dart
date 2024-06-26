import 'dart:core';

extension StringNullExtention on String? {
  bool isEmptyOrNull() => this == null || this!.trim().isEmpty;
  bool isNotEmptyOrNull() => this != null && this!.trim().isNotEmpty;
}
