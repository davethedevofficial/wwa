import 'package:wwa/models/circuit.dart';

class Workout {
  int exerciseTime = 10;
  int exerciseRestTime = 30;
  int circuitRestTime = 60;
  List<Circuit> circuits = [];

  Workout(this.circuits,
      {this.exerciseTime, this.circuitRestTime, this.exerciseRestTime});
}
