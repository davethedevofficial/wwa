import 'package:shared_preferences/shared_preferences.dart';
import 'package:wwa/models/circuit.dart';
import 'package:wwa/models/exercise.dart';
import 'package:wwa/models/workout.dart';

List<Workout> workouts = [
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
      Exercise('Banded Lateral Walk'),
      Exercise('Squats'),
    ]),
  ]),
];
SharedPreferences prefs = null;

getPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
