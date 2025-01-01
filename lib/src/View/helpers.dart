import 'dart:async';

import 'package:flutter/material.dart';

class Helpers {

  static LayoutBuilder responsiveColumnRow(BuildContext context, List<Widget> children) {
    debugPrint("Width: ${MediaQuery.of(context).size.width}");
    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        if (constraints.minWidth > 1500) {
          return Row(
            children: children
          );
        } else {
          return Column(
            children: children,
          );
        }
      }
    );
  }

  static Widget responsiveMenu({required List<Widget> children, required bool isLargeScreen}) {
    return isLargeScreen 
    ? Row(
      children: children,
    )
    : ListView(
      children: children,
    );
  }

  static Widget rowOrWrap({required bool wrap, required List<Widget> children, double spacing = 10}) {

    final wrapWidgets = children.map((widget) {
      if (widget is Flexible) {
        return widget.child; // Return the child of the `Expanded` widget
      }
      return widget; // Return the widget as-is if it's not `Expanded`
    }).toList();
    
    return wrap ? Wrap(
      runSpacing: spacing,
      children: wrapWidgets,
    ) : Row(
      spacing: spacing,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
    
  }

}