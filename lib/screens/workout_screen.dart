import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wwa/widgets/wwa_circle_loader_painter.dart';
import 'package:wwa/widgets/wwa_list.dart';
import 'package:wwa/widgets/wwa_stepper.dart';
import 'package:wwa/widgets/wwa_timer.dart';
import 'package:wwa/widgets/wwa_simple_timer.dart';
import 'package:wwa/helpers/data.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/models/workout.dart';
import 'package:wwa/models/exercise.dart';
import 'package:wwa/widgets/wwa_elevation.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  WWATimer _wwaTimer;
  WWASimpleTimer _wwaRestTimer;

  Workout currentWorkout;
  int currentCircuitIndex;
  int currentExerciseIndex;

  bool autoContinue = true;
  bool isResting = false;
  bool isCompleted = true;
  String restMessage = '';

  bool allCompleted() {
    var completed = true;
    var exercises =
        this.currentWorkout.circuits[this.currentCircuitIndex].exercises;

    exercises.forEach((e) {
      if (e.completed < 2) return completed = false;
    });

    return completed;
  }

  bool firstPassOfCircuitCompleted() {
    var completed = true;
    var exercises =
        this.currentWorkout.circuits[this.currentCircuitIndex].exercises;

    exercises.forEach((e) {
      if (e.completed != 1) return completed = false;
    });

    return completed;
  }

  int nextIncompletedExecise() {
    var exercises =
        this.currentWorkout.circuits[this.currentCircuitIndex].exercises;

    if (this.currentExerciseIndex < exercises.length - 1) {
      for (var i = this.currentExerciseIndex + 1; i < exercises.length; i++) {
        if (exercises[i].completed < 2) return i;
      }
    }

    for (var i = 0; i < exercises.length; i++) {
      if (exercises[i].completed < 2) return i;
    }

    return 0;
  }

  void nextExercise() {
    if (this.currentExerciseIndex <
            this
                    .currentWorkout
                    .circuits[this.currentCircuitIndex]
                    .exercises
                    .length -
                1 &&
        !allCompleted()) {
      // this.currentExerciseIndex++;
      this.currentExerciseIndex = nextIncompletedExecise();
    } else {
      if (allCompleted()) {
        this.currentExerciseIndex = 0;
        if (this.currentCircuitIndex <
            this.currentWorkout.circuits.length - 1) {
          this.currentCircuitIndex++;
        } else {
          workoutCompleted();
        }
      } else {
        this.currentExerciseIndex = nextIncompletedExecise();
        _wwaTimer.resetTimer(true);
      }
    }

    setState(() {
      _controller.play();
      _wwaTimer.resetTimer(true);
    });
  }

  @override
  void initState() {
    autoContinue = prefs.getBool('autoContinue') ?? autoContinue;
    currentWorkout = workouts[0];
    currentCircuitIndex = 0;
    currentExerciseIndex = 0;
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.asset(
      currentWorkout.circuits[currentCircuitIndex]
          .exercises[currentExerciseIndex].clipPath,
    );
    _controller.setLooping(true);
    // _controller = VideoPlayerController.network(
    //   'https://firebasestorage.googleapis.com/v0/b/wwapp-5da9c.appspot.com/o/Banded%20Lateral%20Walk%20-%20Vertical.mp4?alt=media&token=c90b46ba-442e-45eb-97ba-ff27cf93832d',
    // );
//Banded Lateral Walk.mp4
    _initializeVideoPlayerFuture = _controller.initialize();

    _wwaTimer = WWATimer(
      controller: _controller,
      totalTime: currentWorkout.exerciseTime,
    );

    _wwaRestTimer = WWASimpleTimer(
      totalTime: currentWorkout.exerciseRestTime,
    );

    _wwaTimer.addTimeEndListener(() {
      if (this
              .currentWorkout
              .circuits[this.currentCircuitIndex]
              .exercises[this.currentExerciseIndex]
              .completed <
          2)
        this
            .currentWorkout
            .circuits[this.currentCircuitIndex]
            .exercises[this.currentExerciseIndex]
            .completed++;

      rest();
    });

    _wwaRestTimer.addTimeEndListener(() {
      if (autoContinue) {
        _wwaRestTimer.stopTimer();
        isResting = false;
        nextExercise();
      }
    });

    super.initState();
  }

  rest() {
    var restMsg = '';
    var restTime = currentWorkout.exerciseRestTime;

    if (allCompleted()) {
      if (currentCircuitIndex == currentWorkout.circuits.length - 1) {
        return workoutCompleted();
      }

      restTime = currentWorkout.circuitRestTime;
      restMsg =
          '${currentWorkout.circuitRestTime} Seconds rest before next circuit, Circuit ${currentCircuitIndex + 2}';
    } else {
      if (firstPassOfCircuitCompleted()) {
        restTime = currentWorkout.circuitRestTime;
        restMsg =
            '${currentWorkout.circuitRestTime} Seconds rest before repeating circuit ${currentCircuitIndex + 1}';
      } else {
        restTime = currentWorkout.exerciseRestTime;
        var _nCEI = nextIncompletedExecise();
        restMsg =
            '${currentWorkout.exerciseRestTime} Seconds rest before next exercise, ${currentWorkout.circuits[currentCircuitIndex].exercises[_nCEI].name}';
      }
    }

    restMessage = restMsg;

    _wwaRestTimer.totalTime = restTime;
    if (_wwaRestTimer.resetTimer != null) _wwaRestTimer.resetTimer(true);
    setState(() {
      isResting = true;
    });
  }

  void workoutCompleted() {
    setState(() {
      isCompleted = true;
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller));
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: _wwaTimer,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Circuit ${currentCircuitIndex + 1}/${currentWorkout.circuits.length}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Each circuit done twice',
                          style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 30)
                              ],
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        WWAStepper(
                          steps: currentWorkout.circuits.length,
                          currentStep: currentCircuitIndex,
                          onSelected: (index) {
                            setState(() {
                              currentCircuitIndex = index;
                              currentExerciseIndex = currentWorkout
                                      .circuits[currentCircuitIndex]
                                      .exercises
                                      .length -
                                  1;
                              currentExerciseIndex = nextIncompletedExecise();
                              _wwaTimer.resetTimer(false);
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        WWAList(
                            items: currentWorkout
                                .circuits[currentCircuitIndex].exercises,
                            currentItem: currentExerciseIndex,
                            onSelected: (index) {
                              setState(() {
                                currentExerciseIndex = index;
                                _wwaTimer.resetTimer(false);
                              });
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: isResting ? double.infinity : 0,
            color: primaryColor,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    right: 10,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 120,
                              height: 200,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.black.withAlpha(100),
                                )
                              ], borderRadius: BorderRadius.circular(10)),
                              child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    // If the VideoPlayerController has finished initialization, use
                                    // the data it provides to limit the aspect ratio of the video.
                                    return AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        // Use the VideoPlayer widget to display the video.
                                        child: VideoPlayer(_controller));
                                  } else {
                                    // If the VideoPlayerController is still initializing, show a
                                    // loading spinner.
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'NEXT EXERCISE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  shadows: [
                                    Shadow(blurRadius: 30, color: Colors.black)
                                  ],
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _wwaRestTimer == null ? Container() : _wwaRestTimer,
                        SizedBox(height: 20),
                        Text(
                          'REST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          restMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Auto continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch(
                              value: autoContinue,
                              onChanged: (value) {
                                setState(() {
                                  autoContinue = value;
                                  prefs.setBool('autoContinue', autoContinue);
                                });
                              },
                              activeTrackColor: Colors.white.withAlpha(150),
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          child: Text(
                            'CONTINUE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                          elevation: 12,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          color: Colors.white,
                          textColor: Colors.black,
                          onPressed: () {
                            if (_wwaRestTimer.stopTimer != null)
                              _wwaRestTimer.stopTimer();
                            isResting = false;
                            nextExercise();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: isCompleted ? double.infinity : 0,
            color: primaryColor,
            child: SafeArea(
              child: Stack(
                children: [
                  Text(
                    'WELL DONE',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
