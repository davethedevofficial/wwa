import 'package:shared_preferences/shared_preferences.dart';
import 'package:wwa/models/circuit.dart';
import 'package:wwa/models/exercise.dart';
import 'package:wwa/models/workout.dart';
import 'package:wwa/models/workout_plan.dart';

WorkoutPlan workoutPlan = WorkoutPlan([
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
  null,
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
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
]);

SharedPreferences prefs = null;

getPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
