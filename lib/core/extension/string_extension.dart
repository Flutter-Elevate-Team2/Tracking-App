extension StringExtension on String {
  String get toImageUrl {
    if (isEmpty) return "";
    if (startsWith('http')) return this;
    // Prefix with the base API domain for relative paths
    return "https://flower.elevateegy.com/$this";
  }
}