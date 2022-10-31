import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netflix_fe/createpage.dart';
import 'package:netflix_fe/utils/barChartDisplay.dart';
import 'package:netflix_fe/utils/buttons.dart';
import 'package:netflix_fe/utils/lineChartDisplay.dart';
import 'package:netflix_fe/utils/pieChartDisplay.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> collections = ["default"];

  late String collection = collections[0];
  late String newCollection;

  @override
  void initState() {
    getCollections();

    super.initState();
  }

  void addCollection() {
    if (collections.contains(newCollection)) {
      return;
    }
    setState(() {
      collections = [...collections, newCollection];
      newCollection = '';
    });
  }

  Future<void> getCollections() async {
    var url = Uri.http('127.0.0.1:3300', 'collections');
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    List<String> collectionList = (jsonData['result_list'] as List)
        .map((item) => item as String)
        .toList();

    setState(() {
      collections = collectionList;
      collection = collectionList[0];
    });
  }

  void create() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePage(
                  title: 'Create Chart',
                  collections: collections,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: collection == "default"
          ? Container()
          : Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'select Collection to display:',
                    ),
                    DropDown(
                        items: collections,
                        onPress: (newChoice) {
                          setState(() {
                            collection = newChoice!;
                          });
                        },
                        value: collection),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NumberTextField(
                            onChange: (newChoice) {
                              setState(() {
                                newCollection = newChoice!;
                              });
                            },
                            text: "Collection"),
                        const SizedBox(
                          width: 20.0,
                        ),
                        ButtonType1(
                            onPress: addCollection, text: 'Add New Collection')
                      ],
                    ),
                    FutureBuilder(
                        future: getCharts(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text('Loading...'),
                            );
                          } else {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 340,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: snapshot.data
                                      .map<Widget>((ChartDetails item) =>
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: SizedBox(
                                                // height: 300.0,
                                                width: 500.0,
                                                child: item.type == "PIE"
                                                    ? PieChartDisplay(
                                                        releaseYear:
                                                            item.releaseYear1)
                                                    : (item.type == "BAR"
                                                        ? BarChartDisplay(
                                                            releaseYear: item
                                                                .releaseYear1)
                                                        : LineChartDisplay(
                                                            startYear: item
                                                                .releaseYear1,
                                                            endYear: item
                                                                .releaseYear2))),
                                          ))
                                      .toList()),
                            );
                          }
                        })
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => create(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getCharts() async {
    var response =
        await http.get(Uri.http('localhost:3300', 'collections/$collection'));
    var jsonData = jsonDecode(response.body);

    List<ChartDetails> chartDetails = [];
    for (var item in jsonData["data"]) {
      ChartDetails c = ChartDetails(item["chart_type"],
          item["release_year1"].toString(), item["release_year2"].toString());
      chartDetails.add(c);
    }

    return chartDetails;
  }
}

class ChartDetails {
  ChartDetails(this.type, this.releaseYear1, this.releaseYear2);
  final String type;
  final String releaseYear1;
  final String releaseYear2;
}
