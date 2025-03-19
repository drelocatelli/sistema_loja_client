import 'package:flutter/material.dart';

import '../../../../../ViewModel/shared/SharedTheme.dart';

class LogsPagination extends StatefulWidget {
  LogsPagination({super.key, required this.model, required this.fetchCb, this.isNotEmpty = false, this.alignment = Alignment.bottomRight});

  final model;
  Function fetchCb;
  bool isNotEmpty;
  Alignment alignment;

  @override
  State<LogsPagination> createState() => _LogsPaginationState();
}

class _LogsPaginationState extends State<LogsPagination> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      alignment: widget.alignment,
      child: Column(
        children: [
          Visibility(
            visible: widget.isNotEmpty,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.model.totalPages, (idx) {
                  final page =  idx + 1;
                  return TextButton(
                    onPressed: () async {
                      if(widget.model.currentPage == page) return;
                      widget.model.currentPage = page;
                      widget.fetchCb();
                      setState(() {});
                    },
                    child: Tooltip(message: (widget.model.currentPage == page) ? "" : "Página $page", child: Text(page.toString(), style: TextStyle(color: (widget.model.currentPage == page) ? SharedTheme.primaryColor : null))),
                  );
                })
              ),
            ),
          ),
        ],
      ),
    );
  }
}
