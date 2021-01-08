import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/models/workout_plan.dart';
import 'package:wwa/models/workout.dart';
import 'package:wwa/widgets/wwa_elevation.dart';
import 'package:wwa/widgets/wwa_workout_day.dart';
import 'package:intl/intl.dart';
import 'package:wwa/helpers/data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadingJournal = false;
  bool loadingWorkout = false;
  DateTime dateSelected;
  DateFormat format;
  String startDate = '';
  String currentDate = '';
  List<String> daysCompleted = [];

  @override
  void initState() {
    format = new DateFormat("yyyy-MM-dd");
    startDate = prefs.getString('startDate') ?? format.format(DateTime.now());
    daysCompleted =
        prefs.getString('daysCompleted') ?? ['2021-01-08', '2021-01-10'];
    currentDate =
        prefs.getString('currentDate') ?? format.format(DateTime.now());
    print(startDate);
    setState(() {
      dateSelected = DateTime.parse(startDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: dateSelected.isAfter(DateTime.now())
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: WWAElevation(
                color: primaryColor,
                child: RaisedButton(
                  child: loadingWorkout
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text(
                          'BEGIN WORKOUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (loadingWorkout) return;

                    setState(() {
                      loadingWorkout = true;
                    });
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.pushNamed(
                        context,
                        '/workout',
                      );
                    });
                  },
                ),
              ),
            ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
              Color.fromRGBO(22, 24, 26, 1),
              Color.fromRGBO(22, 24, 26, 1),
              // Color.fromRGBO(34, 36, 44, 1),
            ])),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${daysCompleted.length}',
                        style: TextStyle(color: Colors.white, fontSize: 48),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5,
                            width: 180,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 5,
                              width: (180 *
                                  (daysCompleted.length /
                                      workoutPlan.days.length)),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: progressBgColor,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'of ${workoutPlan.days.length.toString()} Days, you got this!',
                            style: TextStyle(
                                color: Colors.white.withAlpha(80),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      for (var i = 0; i < workoutPlan.days.length; i++)
                        WWAWorkoutDay(
                          date:
                              DateTime.parse(startDate).add(Duration(days: i)),
                          done: daysCompleted.contains(format.format(
                              DateTime.parse(startDate)
                                  .add(Duration(days: i)))),
                          active: dateSelected.isAtSameMomentAs(
                              DateTime.parse(startDate).add(Duration(days: i))),
                          onTap: (date) {
                            setState(() {
                              dateSelected = date;
                            });
                          },
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back Tammy!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'All progress takes place outside the comfort zone.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white.withAlpha(150),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 30),
                      RaisedButton(
                        child: loadingJournal
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Fitness Journal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        elevation: 10,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        color: primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if (loadingJournal) return;

                          setState(() {
                            loadingJournal = true;
                          });
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            Navigator.pushNamed(
                              context,
                              '/home',
                            );
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
