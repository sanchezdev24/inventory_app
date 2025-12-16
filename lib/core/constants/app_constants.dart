/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Inventory App';
  static const String hiveBoxName = 'saved_items_box';

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Debounce duration for search
  static const Duration searchDebounce = Duration(milliseconds: 400);
}