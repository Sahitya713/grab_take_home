// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class BarChartDisplay extends StatefulWidget {
  final String releaseYear;
  const BarChartDisplay({super.key, required this.releaseYear});

  @override
  State<BarChartDisplay> createState() => _BarChartDisplayState();
}

class _BarChartDisplayState extends State<BarChartDisplay> {
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
                future: getBarChartData(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  } else {
                    return SfCartesianChart(
                      primaryXAxis: CategoryAxis(maximumLabelWidth: 100),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 10,
                          interval: 1,
                          rangePadding: ChartRangePadding.additional),
                      title: ChartTitle(
                          text: 'Top 10 movies of ${widget.releaseYear}'),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      tooltipBehavior: _tooltipBehavior,
                      series: <ChartSeries<ScoresData, String>>[
                        BarSeries<ScoresData, String>(
                          name: 'IMDB Score',
                          dataSource: snapshot.data,
                          xValueMapper: (ScoresData data, _) => data.title,
                          yValueMapper: (ScoresData data, _) => data.score,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                        ),
                        // BarSeries<ScoresData, String>(
                        //   name: 'IMDB Votes',
                        //   dataSource: snapshot.data,
                        //   xValueMapper: (ScoresData data, _) => data.title,
                        //   yValueMapper: (ScoresData data, _) => data.votes,
                        //   dataLabelSettings:
                        //       const DataLabelSettings(isVisible: true),
                        //   enableTooltip: true,
                        // )
                      ],
                    );
                  }
                })));
  }

  Future getBarChartData() async {
    var response = await http
        .get(Uri.http('localhost:3300', 'scores/${widget.releaseYear}'));
    var jsonData = jsonDecode(response.body);

    List<ScoresData> scores = [];
    for (var item in jsonData["data"]) {
      var score = item["imdb_score"].toDouble();
      var votes = double.parse(item["imdb_votes"]);

      ScoresData c = ScoresData(item["title"], score, votes);
      scores.add(c);
    }
    var reversedList = List<ScoresData>.from(scores.reversed);

    return reversedList;
  }
}

class ScoresData {
  ScoresData(this.title, this.score, this.votes);
  final String title;
  final double score;
  final double votes;
}
