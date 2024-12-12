import 'package:flutter/material.dart';

class PulseAnimation extends StatefulWidget {
  final Widget child; // O widget que será animado

  const PulseAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configura o AnimationController
    _controller = AnimationController(
      duration: Duration(milliseconds: 500), // Duração da animação
      vsync: this,
    )..repeat(reverse: true); // Repete e inverte a animação para simular o "pulsar"

    // Define o intervalo de escala (1.0 = tamanho original)
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child, // Retorna o widget filho animado
        );
      },
      child: widget.child, // O widget que será animado
    );
  }
}
