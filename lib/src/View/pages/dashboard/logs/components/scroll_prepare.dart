import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

/**
 * show scroll on datatables
 */
  Widget scrollPrepare({required Widget child}) {
    final _horizontalController = ScrollController();
    final _verticalScrollController = ScrollController();
    bool _isHorizontalThumbShowing = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scrollbar(
          interactive: true,
          controller: _horizontalController,
          trackVisibility: false,
          thumbVisibility: _isHorizontalThumbShowing,
          child: SingleChildScrollView(
            controller: _horizontalController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Scrollbar(
              interactive: true,
              controller: _verticalScrollController,
              trackVisibility: true,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _verticalScrollController,
                physics: const BouncingScrollPhysics(),
                child: MouseRegion(
                  onHover: (event) => setState(() => _isHorizontalThumbShowing = true),
                  onExit: (event) => setState(() => _isHorizontalThumbShowing = false),
                  child: FittedBox(
                    fit: SharedTheme.isLargeScreen(context) ? BoxFit.scaleDown : BoxFit.fitWidth,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }