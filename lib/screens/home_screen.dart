import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/models/workout_plan.dart';
import 'package:wwa/models/exercise.dart';
import 'package:wwa/models/workout.dart';
import 'package:wwa/widgets/wwa_elevation.dart';
import 'package:wwa/widgets/wwa_workout_day.dart';
import 'package:wwa/widgets/wwa_circuit.dart';
import 'package:intl/intl.dart';
import 'package:wwa/helpers/data.dart';
import 'package:wwa/helpers/notification.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadingJournal = false;
  bool loadingWorkout = false;
  DateTime dateSelected;
  int selectedIndex;
  DateFormat format;
  String startDate = '';
  List<String> daysCompleted = [];
  ScrollController controller;
  String username;
  String greeting;

  @override
  void initState() {
    format = new DateFormat("yyyy-MM-dd");
    loadingJournal = false;
    loadingWorkout = false;
    if (!prefs.containsKey('startDate'))
      prefs.setString('startDate', format.format(DateTime.now()));
    startDate = prefs.getString('startDate') ?? format.format(DateTime.now());
    username = prefs.getString('name') ?? null;
    greeting = (username == null ? 'Hello!' : 'Hi $username!');
    daysCompleted = prefs.getStringList('daysCompleted') ?? [];
    print(startDate);

    controller = new ScrollController(
        initialScrollOffset:
            ((DateTime.now().difference(DateTime.parse(startDate)).inDays) * 60)
                .toDouble());

    // controller.jumpTo(controller.position.maxScrollExtent);
    setState(() {
      dateSelected = DateTime.parse(format.format(DateTime.now()));
      selectedIndex =
          (dateSelected.difference(DateTime.parse(startDate)).inDays) - 1;
    });

    notification.showNotification();

    super.initState();
  }

  Workout getWorkout(date) {
    return workoutPlan
        .days[(date.difference(DateTime.parse(startDate)).inDays)];
  }

  String heading() {
    return isToday(dateSelected)
        ? 'Today\'s Exercises'
        : 'Exercises for ${dateSelected.day} ${getMonthAb(dateSelected.month)}';
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: dateSelected.isAfter(DateTime.now()) ||
                getWorkout(dateSelected) == null
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

                      if (dateSelected.isAfter(DateTime.now()) ||
                          getWorkout(dateSelected) == null) return;

                      prefs.setInt('selectedIndex', selectedIndex);
                      setState(() {
                        loadingWorkout = true;
                      });
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        Navigator.pushNamed(
                          context,
                          '/workout',
                        ).then((value) {
                          setState(() {
                            loadingWorkout = false;
                          });
                        });
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
                    padding: EdgeInsets.only(
                        top: 20, bottom: 0, left: 20, right: 20),
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
                              height: 8,
                              width: 180,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 8,
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
                            SizedBox(height: 10),
                            Text(
                              'of ${workoutPlan.days.length.toString()} Days, you got this!',
                              style: TextStyle(
                                  color: Colors.white.withAlpha(80),
                                  fontSize: 14,
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
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => WWAWorkoutDay(
                        date: DateTime.parse(startDate).add(Duration(days: i)),
                        done: daysCompleted.contains(format.format(
                            DateTime.parse(startDate).add(Duration(days: i)))),
                        active: dateSelected.isAtSameMomentAs(
                            DateTime.parse(startDate).add(Duration(days: i))),
                        restDay: workoutPlan.days[i] == null,
                        onTap: (date) {
                          setState(() {
                            dateSelected = date;
                            selectedIndex = i;
                          });
                        },
                      ),
                      controller: controller,
                      itemCount: workoutPlan.days.length,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0, left: 20, right: 0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'All progress takes place outside the comfort zone.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white.withAlpha(150),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        (journalFeature
                            ? RaisedButton(
                                child: loadingJournal
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      )
                                    : Text(
                                        'Fitness Journal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                elevation: 10,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                color: primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (loadingJournal) return;

                                  setState(() {
                                    loadingJournal = true;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 1000), () {
                                    Navigator.pushNamed(
                                      context,
                                      '/home',
                                    ).then((value) {
                                      setState(() {
                                        loadingJournal = false;
                                      });
                                    });
                                  });
                                },
                              )
                            : Container()),
                        (getWorkout(dateSelected) == null)
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/rest.png',
                                      width: double.infinity,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 20, left: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: primaryColor,
                                      width: 5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Stack(
                                        overflow: Overflow.visible,
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: -12.5,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              '${heading()}',
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                height: 0.9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Builder(builder: (context) {
                                      if (getWorkout(dateSelected) != null) {
                                        List<WWACircuit> circuits = [];
                                        for (var i = 0;
                                            i <
                                                getWorkout(dateSelected)
                                                    .circuits
                                                    .length;
                                            i++)
                                          circuits.add(WWACircuit(
                                              title: 'Circuit ${i + 1}',
                                              circuit: getWorkout(dateSelected)
                                                  .circuits[i]));
                                        return Column(
                                          children: circuits,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                    SizedBox(
                                      height: 100,
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
