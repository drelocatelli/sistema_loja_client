  import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showSelectableModal({
    required BuildContext context,
    required Widget Function(StateSetter) searchBody,
    required List<Map<String, dynamic>> mappedItems,
    required String keyName,
    required String labelName,
    required Function selectCategoryCb,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        List<Map<String, dynamic>> itemsToDisplay = mappedItems;

        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: searchBody(setState),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: itemsToDisplay.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(itemsToDisplay[index][labelName].toString()),
                        onTap: () {
                          String selected = itemsToDisplay[index][keyName].toString();
                          selectCategoryCb(selected);
                          context.pop(itemsToDisplay[index][keyName]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }