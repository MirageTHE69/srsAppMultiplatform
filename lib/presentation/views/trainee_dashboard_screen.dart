import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/main.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srsappmultiplatform/presentation/widgets/CustomMaxExerciseCard.dart';

class TraineeDashboardScreen extends StatefulWidget {
  @override
  _TraineeDashboardScreenState createState() => _TraineeDashboardScreenState();
}

class _TraineeDashboardScreenState extends State<TraineeDashboardScreen> {
  List<charts.Series<TrainingVolume, String>> seriesList = [];
  String selectedTimeRange = 'Week';

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, _) {
          final user = userViewModel.user;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 50, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (user != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome, ${user.username}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.pinkAccent.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 25,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomMaxExerciseCard(
                            icon: Icons.sports_gymnastics,
                            title: "Max PushUps",
                            value:
                                user?.exerciseLevel?.pushUpReps?.toString() ??
                                    '0'),
                        CustomMaxExerciseCard(
                            icon: Icons.sports_gymnastics,
                            title: "Max PullUps",
                            value:
                                user?.exerciseLevel?.pullUpReps?.toString() ??
                                    '0'),
                        CustomMaxExerciseCard(
                            icon: Icons.sports_gymnastics,
                            title: "Max BenchPress",
                            value:
                                user?.exerciseLevel?.benchPress?.toString() ??
                                    '0'),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    "Volume Of Training",
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                     textStyle: TextStyle(fontSize: 25),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedTimeRange,
                    items: [
                      DropdownMenuItem(
                        child: Text("Week"),
                        value: 'Week',
                      ),
                      DropdownMenuItem(
                        child: Text("Day"),
                        value: 'Day',
                      ),
                      DropdownMenuItem(
                        child: Text("Month"),
                        value: 'Month',
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeRange = newValue!;
                        seriesList = _createSampleData();
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 250,
                    child: charts.BarChart(
                      seriesList,
                      animate: true,
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 14,
                            color: charts.MaterialPalette.blue.shadeDefault,
                          ),
                        ),
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 14,
                            color: charts.MaterialPalette.blue.shadeDefault,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Create sample data for the chart
  List<charts.Series<TrainingVolume, String>> _createSampleData() {
    final data = _generateDataForTimeRange(selectedTimeRange);

    return [
      charts.Series<TrainingVolume, String>(
        id: 'TrainingVolume',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TrainingVolume trainingVolume, _) => trainingVolume.week,
        measureFn: (TrainingVolume trainingVolume, _) => trainingVolume.volume,
        data: data,
      )
    ];
  }

  List<TrainingVolume> _generateDataForTimeRange(String timeRange) {
    // Replace the following code with your actual data for different time ranges
    switch (timeRange) {
      case 'Day':
        return [
          TrainingVolume('Day 1', 20),
          TrainingVolume('Day 2', 10),
          TrainingVolume('Day 3', 30),
          TrainingVolume('Day 4', 25),
          TrainingVolume('Day 5', 25),
          TrainingVolume('Day 6', 25),
          TrainingVolume('Day 7', 25),
        ];
      case 'Month':
        return [
          TrainingVolume('Month 1', 400),
          TrainingVolume('Month 2', 320),
          TrainingVolume('Month 3', 600),
          TrainingVolume('Month 4', 450),
        ];
      case 'Week':
      default:
        return [
          TrainingVolume('Week 1', 100),
          TrainingVolume('Week 2', 80),
          TrainingVolume('Week 3', 200),
          TrainingVolume('Week 4', 150),
        ];
    }
  }
}

class TrainingVolume {
  final String week;
  final int volume;

  TrainingVolume(this.week, this.volume);
}
