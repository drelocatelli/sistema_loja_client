import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}


Widget relatorios() {
  return SelectionArea(
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          const Text("Relatórios de vendas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SfCartesianChart(
            // Initialize category axis
            primaryXAxis: const CategoryAxis(),

            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                // Bind data source
                dataSource:  <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 40),
                  SalesData('Jun', 32),
                  SalesData('Jul', 35)
                ],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales
              )
            ]
          )
        ],
      ),
    ),
  );
}
