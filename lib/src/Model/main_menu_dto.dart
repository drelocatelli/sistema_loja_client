import 'dart:ui';

class MainMenuDTO {
  final String label;
  final VoidCallback fn; // Define a function type for the callback
  final List<SubmenuDTO>? submenu;

  MainMenuDTO({required this.label, required this.fn, this.submenu});
}

class SubmenuDTO {
  final String label;
  final VoidCallback fn; // Define a function type for the callback

  SubmenuDTO({required this.label, required this.fn});
}