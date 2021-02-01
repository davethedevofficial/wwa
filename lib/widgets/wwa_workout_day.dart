import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/helpers/data.dart';

class WWAWorkoutDay extends StatelessWidget {
  final DateTime date;
  final bool active;
  final bool restDay;
  final bool done;
  Widget main;
  Widget sub;
  final Function(DateTime date) onTap;

  WWAWorkoutDay({
    Key key,
    @required this.date,
    @required this.onTap,
    this.active = false,
    this.done = false,
    this.restDay = false,
  }) {
    if (done) {
      this.main = Text(
        isToday(date)
            ? 'TODAY'
            : '${this.date.day.toString()} ${getMonthAb(this.date.month)}',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      );
      this.sub = Icon(
        Icons.check,
        color: primaryColor,
        size: 18,
      );
    } else if (isToday(date)) {
      this.main = Text(
        'TODAY',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      );
      this.sub = Text(
        this.restDay ? 'REST DAY!' : 'CRUSH IT!',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: (Colors.white), fontWeight: FontWeight.bold, fontSize: 8),
      );
    } else {
      this.main = Text(
        this.date.day.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      );
      this.sub = Text(
        getMonthAb(this.date.month),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.onTap(this.date);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: this.active
                ? primaryColor
                : (this.restDay
                    ? Colors.orangeAccent.withAlpha(100)
                    : Colors.white.withAlpha(40)),
          ),
        ),
        child: Center(
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 3,
            children: [main, sub],
          ),
        ),
      ),
    );
  }
}
