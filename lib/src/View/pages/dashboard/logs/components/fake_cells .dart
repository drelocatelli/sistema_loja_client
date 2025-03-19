import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/View/components/shimmer_cell.dart';
import 'package:shimmer/shimmer.dart';

fakeCells(int columnsLength) {
   final fakeCells = List.generate(columnsLength, (index) => DataCell(
      Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ShimmerCell(width: 120)
          ),
    ));
  return fakeCells;
}