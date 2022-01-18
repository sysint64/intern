String truncateWithEllipsis(String str, int cutoff) {
  return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}...';
}

extension StringExtension on String {
  String capitalize() {
    if (this == "") return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
