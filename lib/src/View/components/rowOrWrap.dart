import 'package:flutter/material.dart';

Widget rowOrWrap(BuildContext context, {required List<Widget> children, required bool wrap, column = false, double spacing = 0}) {
  final double widget = MediaQuery.of(context).size.width;

  final wrapChildren = children.map((widget) {
    if (widget is Expanded) {
      return widget.child; // Return the child of the `Expanded` widget
    }
    return widget; // Return the widget as-is if it's not `Expanded`
  }).toList();

  if(wrap && column) {
    return Column(children: wrapChildren, spacing: spacing);
  }

  if(wrap) {
    return Wrap(children: wrapChildren, spacing: spacing);
  }
  
  return widget >= 800
      ? IntrinsicHeight(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children
            , spacing: spacing
            ),
      )
      : Wrap(children: wrapChildren);
}