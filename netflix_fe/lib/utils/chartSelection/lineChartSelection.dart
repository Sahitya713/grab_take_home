import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netflix_fe/utils/buttons.dart';
import 'package:netflix_fe/utils/lineChartDisplay.dart';
import 'package:http/http.dart' as http;

class LineChartSelection extends StatefulWidget {
  final String selectedCollection;
  const LineChartSelection({super.key, required this.selectedCollection});

  @override
  State<LineChartSelection> createState() => _LineChartSelectionState();
}

class _LineChartSelectionState extends State<LineChartSelection> {
  bool _lineChartDisplay = false;
  late String startYear;
  late String endYear;

  Future saveChart() async {
    var url = Uri.http('localhost:3300', 'collections');

    var body = jsonEncode(<String, String>{
      'collection': widget.selectedCollection,
      'chartType': 'LINE',
      'startYear': startYear,
      'endYear': endYear
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select release year range:',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberTextField(
                onChange: (newChoice) {
                  setState(() {
                    startYear = newChoice!;
                  });
                },
                text: "start year"),
            const Text("   -   "),
            NumberTextField(
                onChange: (newChoice) {
                  setState(() {
                    endYear = newChoice!;
                  });
                },
                text: "end year")
          ],
        ),
        ButtonType1(
            onPress: () {
              setState(() {
                _lineChartDisplay = true;
              });
            },
            text: "Confirm"),
        _lineChartDisplay
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 300.0,
                    width: 500.0,
                    child: LineChartDisplay(
                      startYear: startYear,
                      endYear: endYear,
                    ),
                  ),
                  ButtonType1(
                      onPress: () {
                        saveChart();
                      },
                      text: "Save"),
                ],
              )
            : Container(),
      ],
    );
  }
}
