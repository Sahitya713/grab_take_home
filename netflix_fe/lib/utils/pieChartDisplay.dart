// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class PieChartDisplay extends StatefulWidget {
  final String releaseYear;
  const PieChartDisplay({super.key, required this.releaseYear});

  @override
  State<PieChartDisplay> createState() => _PieChartDisplayState();
}

class _PieChartDisplayState extends State<PieChartDisplay> {
  // late List<ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    // getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder(
                future: getChartData(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  } else {
                    return SfCircularChart(
                      title: ChartTitle(
                          text:
                              'Distribution of Shows and Movies in ${widget.releaseYear}'),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: snapshot.data,
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.count,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                        )
                      ],
                    );
                  }
                })));
  }

  Future getChartData() async {
    var response = await http
        .get(Uri.http('localhost:3300', 'distribution/${widget.releaseYear}'));
    var jsonData = jsonDecode(response.body);

    List<ChartData> chartData = [];
    for (var item in jsonData["data"]) {
      ChartData c = ChartData(item["type"] == "SHOW" ? "Shows" : "Movies",
          int.parse(item["count"]));
      chartData.add(c);
    }

    return chartData;
    // setState(() {
    //   _chartData = chartData;
    // });
  }
}

class ChartData {
  ChartData(this.category, this.count);
  final String category;
  final int count;
}
