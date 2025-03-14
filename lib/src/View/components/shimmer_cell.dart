import 'package:flutter/material.dart';

class ShimmerCell extends StatelessWidget {
  final double width;

  const ShimmerCell({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}