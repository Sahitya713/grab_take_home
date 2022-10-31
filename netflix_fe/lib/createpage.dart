import 'package:flutter/material.dart';
import 'package:netflix_fe/utils/buttons.dart';
import 'package:netflix_fe/utils/chartSelection/barChartSelection.dart';
import 'package:netflix_fe/utils/chartSelection/lineChartSelection.dart';
import 'package:netflix_fe/utils/chartSelection/piechartselection.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key, required this.title, required this.collections});
  final String title;
  final List<String> collections;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late String collection = widget.collections[0];
  bool displayPieChart = false;
  bool displaylineChart = false;
  List<String> chartTypes = [
    'Average runtime line chart',
    'movie-show ratio',
    'top-10'
  ];
  late String chartType = chartTypes[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Select a Chart type:',
                      ),
                      DropDown(
                          items: chartTypes,
                          onPress: (newChoice) {
                            setState(() {
                              chartType = newChoice!;
                            });
                          },
                          value: chartType),
                    ],
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Select a collection to save chart to:',
                      ),
                      DropDown(
                          items: widget.collections,
                          onPress: (newChoice) {
                            setState(() {
                              collection = newChoice!;
                            });
                          },
                          value: collection),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),
              chartType == "movie-show ratio"
                  ? PieChartSelection(selectedCollection: collection)
                  : (chartType == "top-10")
                      ? BarChartSelection(selectedCollection: collection)
                      : LineChartSelection(selectedCollection: collection)
            ],
          ),
        ),
      ),
    );
  }
}
