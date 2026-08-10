
abstract final class ModelNormalizer {
  static String string(Object? value) => value?.toString() ?? '';

  static String? nullableString(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int integer(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool boolean(Object? value, {bool fallback = true}) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }

  static Map<String, Object?> map(Object? value) {
    if (value is Map) return Map<String, Object?>.from(value);
    return const {};
  }

  static List<Map<String, Object?>> maps(Object? value) {
    if (value is! Iterable) return const [];
    return value.map(map).toList(growable: false);
  }

  static List<String> strings(Object? value) {
    if (value is! Iterable) return const [];
    return value.map(string).toList(growable: false);
  }

  static String slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  static String initials(String value, {String fallback = 'CL'}) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return fallback;
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length.clamp(1, 2))
          .toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static void requireNonEmpty(Map<String, String> values) {
    for (final entry in values.entries) {
      if (entry.value.trim().isEmpty) {
        throw FormatException('${entry.key} must not be empty.');
      }
    }
  }

  static void requireKeys<T>(
    Map<String, T> values,
    Iterable<String> keys,
    String path,
  ) {
    for (final key in keys) {
      final value = values[key];
      if (value == null || (value is String && value.trim().isEmpty)) {
        throw FormatException('$path.$key is required.');
      }
    }
  }

  static List<T> enabledAndOrdered<T>(
    Iterable<T> values, {
    required bool Function(T value) enabled,
    required int Function(T value) order,
  }) {
    final items = values.where(enabled).toList(growable: false);
    items.sort((first, second) => order(first).compareTo(order(second)));
    return items;
  }
}
