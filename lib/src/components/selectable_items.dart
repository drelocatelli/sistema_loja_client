  import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showSelectableModal({
    required BuildContext context,
    required Widget searchBody,
    required List<Map<String, dynamic>> mappedItems,
    required String keyName,
    required String labelName,
    required Function selectCategoryCb,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            searchBody,
            Expanded(
              child: ListView.builder(
                itemCount: mappedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(mappedItems[index][labelName].toString()),
                    onTap: () {
                      String selected = mappedItems[index][keyName].toString();
                      selectCategoryCb(selected);
                      context.pop(mappedItems[index][keyName]);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }