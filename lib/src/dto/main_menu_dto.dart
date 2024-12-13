import 'dart:ui';

class MainMenuDTO {
  final String label;
  final VoidCallback fn; // Define a function type for the callback

  MainMenuDTO({required this.label, required this.fn});
}
