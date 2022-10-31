// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netflix_fe/utils/buttons.dart';
import 'package:netflix_fe/utils/pieChartDisplay.dart';
import 'package:http/http.dart' as http;

class PieChartSelection extends StatefulWidget {
  final String selectedCollection;
  const PieChartSelection({super.key, required this.selectedCollection});

  @override
  State<PieChartSelection> createState() => _PieChartSelectionState();
}

class _PieChartSelectionState extends State<PieChartSelection> {
  bool _pieChartDisplay = false;
  late String releaseYear;

  Future saveChart() async {
    var url = Uri.http('localhost:3300', 'collections');

    var body = jsonEncode(<String, String>{
      'collection': widget.selectedCollection,
      'chartType': 'PIE',
      'startYear': releaseYear,
      'endYear': '0'
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
          'Select release year:',
        ),
        NumberTextField(
            onChange: (newChoice) {
              setState(() {
                releaseYear = newChoice!;
              });
            },
            text: "release year"),
        ButtonType1(
            onPress: () {
              setState(() {
                _pieChartDisplay = true;
              });
            },
            text: "Confirm"),
        _pieChartDisplay
            ? Column(
                children: [
                  SizedBox(
                    height: 300.0,
                    width: 500.0,
                    child: PieChartDisplay(releaseYear: releaseYear),
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
