import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RefreshComponent extends StatefulWidget {
  RefreshComponent({super.key, this.isLoading = false});

  bool isLoading;

  @override
  State<RefreshComponent> createState() => _RefreshComponentState();
}

class _RefreshComponentState extends State<RefreshComponent> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: false);
    if (widget.isLoading) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
   @override
  void didUpdateWidget(covariant RefreshComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat(); // Retoma a animação
      } else {
        _controller.stop(); // Pausa a animação
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: FaIcon(FontAwesomeIcons.sync, size: 20, color: Colors.black.withOpacity(0.6))
    );
  }
}