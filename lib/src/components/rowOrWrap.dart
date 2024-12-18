import 'package:flutter/material.dart';

Widget rowOrWrap(BuildContext context, {required List<Widget> children, required bool wrap}) {
  final double widget = MediaQuery.of(context).size.width;

  final wrapChildren = children.map((widget) {
    if (widget is Expanded) {
      return widget.child; // Return the child of the `Expanded` widget
    }
    return widget; // Return the widget as-is if it's not `Expanded`
  }).toList();

  debugPrint("wrap: ${wrap.toString()}");

  if(wrap) {
    return Wrap(children: wrapChildren);
  }
  
  return widget >= 800
      ? IntrinsicHeight(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children),
      )
      : Wrap(children: wrapChildren);
}