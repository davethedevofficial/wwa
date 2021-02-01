import 'package:shared_preferences/shared_preferences.dart';
import 'package:wwa/models/circuit.dart';
import 'package:wwa/models/exercise.dart';
import 'package:wwa/models/workout.dart';
import 'package:wwa/models/workout_plan.dart';

bool journalFeature = false;
WorkoutPlan workoutPlan = WorkoutPlan([
  Workout([
    Circuit([
      Exercise(Exercise.squats),
      Exercise(Exercise.curtsyLunge),
      Exercise(Exercise.gluteBridges),
      Exercise(Exercise.donkeyKicks),
    ]),
    Circuit([
      Exercise(Exercise.froggers),
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.bodyweightTricepDips),
      Exercise(Exercise.superwoman),
    ]),
    Circuit([
      Exercise(Exercise.plankWithLegRaise),
      Exercise(Exercise.scissorKicks),
      Exercise(Exercise.bicycleCrunches),
      Exercise(Exercise.vSitWithExtension),
    ]),
  ], exerciseTime: 30, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.squats),
      Exercise(Exercise.lunges),
      Exercise(Exercise.frogPumps),
      Exercise(Exercise.donkeyKicks),
    ]),
    Circuit([
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.bodyweightTricepDips),
      Exercise(Exercise.superwoman),
    ]),
    Circuit([
      Exercise(Exercise.commandoPlank),
      Exercise(Exercise.scissorKicks),
      Exercise(Exercise.straightLegToeTouches),
      Exercise(Exercise.vSitWithExtension),
    ]),
  ], exerciseTime: 30, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.jumpSquats),
      Exercise(Exercise.lunges),
      Exercise(Exercise.frogPumps),
      Exercise(Exercise.donkeyKicks),
    ]),
    Circuit([
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.crabToeTouch),
      Exercise(Exercise.bodyweightTricepDips),
      Exercise(Exercise.froggers),
    ]),
    Circuit([
      Exercise(Exercise.commandoPlank),
      Exercise(Exercise.russainTwists),
      Exercise(Exercise.straightLegToeTouches),
      Exercise(Exercise.birdDog),
    ]),
  ], exerciseTime: 30, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  null,
  Workout([
    Circuit([
      Exercise(Exercise.jumpSquats),
      Exercise(Exercise.bandedLateralWalk),
      Exercise(Exercise.gluteBridges),
      Exercise(Exercise.sideLunge),
    ]),
    Circuit([
      Exercise(Exercise.commandoPlank),
      Exercise(Exercise.crabToeTouch),
      Exercise(Exercise.superwoman),
      Exercise(Exercise.froggers),
    ]),
    Circuit([
      Exercise(Exercise.heelTaps),
      Exercise(Exercise.russainTwists),
      Exercise(Exercise.plank),
      Exercise(Exercise.vSitWithExtension),
    ]),
  ], exerciseTime: 40, exerciseRestTime: 20, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.curtsyLunge),
      Exercise(Exercise.squats),
      Exercise(Exercise.singleLegGluteBridge),
      Exercise(Exercise.frogPumps),
    ]),
    Circuit([
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.crabToeTouch),
      Exercise(Exercise.bodyweightTricepDips),
      Exercise(Exercise.froggers),
    ]),
    Circuit([
      Exercise(Exercise.sidePlank),
      Exercise(Exercise.straightLegToeTouches),
      Exercise(Exercise.plank),
      Exercise(Exercise.heelTaps),
    ]),
  ], exerciseTime: 40, exerciseRestTime: 20, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.curtsyLunge),
      Exercise(Exercise.bandedLateralWalk),
      Exercise(Exercise.singleLegGluteBridge),
      Exercise(Exercise.bodyweightLegExtension),
    ]),
    Circuit([
      Exercise(Exercise.superwoman),
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.bodyweightTricepDips),
    ]),
    Circuit([
      Exercise(Exercise.sidePlank),
      Exercise(Exercise.straightLegToeTouches),
      Exercise(Exercise.bicycleCrunches),
      Exercise(Exercise.plankWithLegRaise),
    ]),
  ], exerciseTime: 40, exerciseRestTime: 20, circuitRestTime: 60),
  null,
  null,
  Workout([
    Circuit([
      Exercise(Exercise.squats),
      Exercise(Exercise.bodyweightLegExtension),
      Exercise(Exercise.gluteBridges),
      Exercise(Exercise.donkeyKicks),
    ]),
    Circuit([
      Exercise(Exercise.superwoman),
      Exercise(Exercise.bodyweightTricepDips),
      Exercise(Exercise.commandoPlank),
      Exercise(Exercise.kneelingPushUps),
    ]),
    Circuit([
      Exercise(Exercise.straightLegToeTouches),
      Exercise(Exercise.russainTwists),
      Exercise(Exercise.plankWithLegRaise),
      Exercise(Exercise.scissorKicks),
    ]),
  ], exerciseTime: 50, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.inAndOutJump),
      Exercise(Exercise.bodyweightLegExtension),
      Exercise(Exercise.gluteBridges),
      Exercise(Exercise.sideLunge),
    ]),
    Circuit([
      Exercise(Exercise.crabToeTouch),
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.froggers),
      Exercise(Exercise.commandoPlank),
    ]),
    Circuit([
      Exercise(Exercise.vSitWithExtension),
      Exercise(Exercise.birdDog),
      Exercise(Exercise.plankWithLegRaise),
      Exercise(Exercise.heelTaps),
    ]),
  ], exerciseTime: 50, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.inAndOutJump),
      Exercise(Exercise.bandedLateralWalk),
      Exercise(Exercise.frogPumps),
      Exercise(Exercise.sideLunge),
    ]),
    Circuit([
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.froggers),
      Exercise(Exercise.commandoPlank),
    ]),
    Circuit([
      Exercise(Exercise.sidePlank),
      Exercise(Exercise.birdDog),
      Exercise(Exercise.plank),
      Exercise(Exercise.heelTaps),
    ]),
  ], exerciseTime: 50, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  null,
  Workout([
    Circuit([
      Exercise(Exercise.jumpingLunges),
      Exercise(Exercise.singleLegGluteBridge),
      Exercise(Exercise.squats),
      Exercise(Exercise.sideLunge),
    ]),
    Circuit([
      Exercise(Exercise.superwoman),
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.crabToeTouch),
      Exercise(Exercise.commandoPlank),
    ]),
    Circuit([
      Exercise(Exercise.bicycleCrunches),
      Exercise(Exercise.birdDog),
      Exercise(Exercise.plank),
      Exercise(Exercise.scissorKicks),
    ]),
  ], exerciseTime: 60, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.lunges),
      Exercise(Exercise.singleLegGluteBridge),
      Exercise(Exercise.inAndOutJump),
      Exercise(Exercise.bandedLateralWalk),
    ]),
    Circuit([
      Exercise(Exercise.bodyweightTricepDips),
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.crabToeTouch),
      Exercise(Exercise.froggers),
    ]),
    Circuit([
      Exercise(Exercise.russainTwists),
      Exercise(Exercise.bicycleCrunches),
      Exercise(Exercise.sidePlank),
      Exercise(Exercise.vSitWithExtension),
    ]),
  ], exerciseTime: 60, exerciseRestTime: 30, circuitRestTime: 60),
  null,
  Workout([
    Circuit([
      Exercise(Exercise.bandedLateralWalk),
      Exercise(Exercise.jumpingLunges),
      Exercise(Exercise.squats),
      Exercise(Exercise.curtsyLunge),
    ]),
    Circuit([
      Exercise(Exercise.kneelingPushUps),
      Exercise(Exercise.mountainClimbers),
      Exercise(Exercise.superwoman),
      Exercise(Exercise.crabToeTouch),
    ]),
    Circuit([
      Exercise(Exercise.plank),
      Exercise(Exercise.scissorKicks),
      Exercise(Exercise.straightLegToeTouches),
      Exercise(Exercise.birdDog),
    ]),
  ], exerciseTime: 60, exerciseRestTime: 30, circuitRestTime: 60),
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
