import 'package:shared_preferences/shared_preferences.dart';
import 'package:wwa/models/circuit.dart';
import 'package:wwa/models/exercise.dart';
import 'package:wwa/models/workout.dart';
import 'package:wwa/models/workout_plan.dart';

WorkoutPlan workoutPlan = WorkoutPlan([
  Workout([
    Circuit([
      Exercise('Squats'),
    ]),
  ]),
  Workout([
    Circuit([
      Exercise('Banded Lateral Walk'),
      Exercise('Squats'),
      Exercise('Superman'),
      Exercise('Side Plank'),
    ]),
    Circuit([
      Exercise('Banded Lateral Walk'),
      Exercise('Squats'),
    ]),
    Circuit([
      Exercise('Scissor Kicks'),
      Exercise('Jumping Lunges'),
    ]),
  ]),
  Workout([]),
  Workout([]),
  null,
  Workout([]),
  Workout([]),
  Workout([]),
  null,
  Workout([]),
  Workout([]),
  Workout([]),
  null,
  Workout([]),
  Workout([]),
  Workout([]),
  Workout([]),
  null,
  Workout([]),
  Workout([]),
  Workout([]),
  Workout([]),
]);

SharedPreferences prefs = null;

getPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

bool isToday(DateTime date) {
  return date.month == DateTime.now().month && date.day == DateTime.now().day;
}

getMonthAb(monthNum) {
  return [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ][monthNum - 1];
}
