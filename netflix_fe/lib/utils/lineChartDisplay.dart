import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LineChartDisplay extends StatefulWidget {
  final String startYear;
  final String endYear;
  const LineChartDisplay(
      {super.key, required this.startYear, required this.endYear});

  @override
  State<LineChartDisplay> createState() => _LineChartDisplayState();
}

class _LineChartDisplayState extends State<LineChartDisplay> {
  // late List<RuntimeData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
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
              return SfCartesianChart(
                title: ChartTitle(
                    text:
                        'Yearly average runtime analysis - ${widget.startYear} to ${widget.endYear}'),
                // legend: Legend(isVisible: true),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries>[
                  LineSeries<RuntimeData, double>(
                      name: "Average Runtime",
                      dataSource: snapshot.data,
                      xValueMapper: (RuntimeData data, _) => data.year,
                      yValueMapper: (RuntimeData data, _) => data.runtime,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true)
                ],
                primaryXAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    decimalPlaces: 0),
                // primaryYAxis: NumericAxis(
                //     labelFormat: '{value}M',
                //     numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
              );
            }
          }),
    ));
  }

  // List<RuntimeData> getChartData() {
  //   final List<RuntimeData> chartData = [
  //     RuntimeData(2017, 25),
  //     RuntimeData(2018, 12),
  //     RuntimeData(2019, 24),
  //     RuntimeData(2020, 18),
  //     RuntimeData(2021, 30)
  //   ];
  //   return chartData;
  // }
  Future getChartData() async {
    var url = Uri.http('localhost:3300', 'runtimes');
    // var body = {'startYear': ${widget.startYear}, 'endYear': ${widget.endYear}};
    var body = jsonEncode(<String, String>{
      'startYear': widget.startYear,
      'endYear': widget.endYear
    });

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    var jsonData = jsonDecode(response.body);

    List<RuntimeData> runtimeData = [];
    for (var item in jsonData["data"]) {
      var year = item["release_year"].toDouble();

      var x = double.parse(item["avg"]);
      var runtime = double.parse(x.toStringAsFixed(2));
      RuntimeData c = RuntimeData(year, runtime);

      runtimeData.add(c);
    }

    return runtimeData;
  }
}

class RuntimeData {
  RuntimeData(this.year, this.runtime);
  final double year;
  final double runtime;
}
