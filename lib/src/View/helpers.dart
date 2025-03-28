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
        return widget.child;
      }
      return widget;
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

  static String truncateText({required String text, int length = 5}) {
    if (text.length <= length) {
      return text;
    }
    return '${text.substring(0, length)}...';
  }


}