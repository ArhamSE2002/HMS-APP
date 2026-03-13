class AppFormatters {
  /// Formats amount for display (e.g., 160000 -> "160.0k")
  static String formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    }
    return amount.toStringAsFixed(0);
  }

  /// Formats department key to a display name (e.g., "patient_visit" -> "Patient Visit")
  static String formatDeptName(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
