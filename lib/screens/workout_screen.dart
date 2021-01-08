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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wakelock/wakelock.dart';

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
  bool musicMuted = false;
  bool soundMuted = false;
  bool isResting = false;
  bool isCompleted = false;
  String restMessage = '';
  AudioPlayer player;
  int soundId;
  List<String> music = [
    'CHRIS_HERIA___FOCUS.mp3',
    'CHRIS_HERIA___ZEN.mp3',
    'NEFFEX___Alive.mp3',
    'NEFFEX___Best_of_Me.mp3',
    'NEFFEX___Careless.mp3',
    'NEFFEX___Chance.mp3',
    'NEFFEX___Cold.mp3',
    'NEFFEX___Comeback.mp3',
    'NEFFEX___Coming_For_You.mp3',
    'NEFFEX___Crown.mp3',
    'NEFFEX___Dangerous.mp3',
    'NEFFEX___Destiny.mp3',
    'NEFFEX___Failure.mp3',
    'NEFFEX___Fight_Back.mp3',
    'NEFFEX___Grateful.mp3',
    'NEFFEX___Life.mp3',
    'NEFFEX___Never_Give_Up.mp3',
    'NEFFEX___Play.mp3',
    'NEFFEX___Rumors.mp3',
    'NEFFEX___Soldier.mp3',
    'NEFFEX___Watch_Me.mp3',
    'Street_Workout.mp3',
    'NEFFEX___Things_Are_Gonna_Get_Better.mp3',
    'NEFFEX___Be_Somebody_ft_ROZES.mp3'
  ];
  List<String> playlist = [];

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
      }
    }

    setState(() {
      _wwaTimer.resetTimer(true);
    });
  }

  loadMusic() async {
    music.shuffle();
    playlist = music.sublist(0, 10);
    // await player.setAsset("assets/music/neffex__best_of_me.mp3");
    await player.setAudioSource(
      ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: playlist
            .map((e) => AudioSource.uri(Uri.parse("asset:///assets/music/$e")))
            .toList(),
      ),
      // Playback will be prepared to start from track1.mp3
      initialIndex: 0, // default
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    );

    player.currentIndexStream.listen((i) {
      var song = "${playlist[i]}";
      song = song.replaceAll('___', ' - ');
      song = song.replaceAll('_', ' ');
      song = song.replaceAll('.mp3', '');
      Fluttertoast.showToast(
          msg: 'Song ~ $song',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    });

    await player.setShuffleModeEnabled(true);
    await player.shuffle();

    if (!musicMuted) await player.play();
  }

  playMusic() async {
    // pool = Soundpool(streamType: StreamType.music, maxStreams: 1);
    // // if (pool != null) pool.release();
    // soundId = await rootBundle
    //     .load('assets/music/neffex__best_of_me.mp3')
    //     .then((ByteData soundData) {
    //   return pool.load(soundData);
    // });

    // pool.play(soundId);
  }

  void _initController(String asset, {bool autoPlay = true}) {
    _controller = VideoPlayerController.asset(asset,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _controller.setLooping(true);
    _controller.setVolume(0);
    if (autoPlay) _controller.play();
    if (_wwaTimer != null) _wwaTimer.setController(_controller);
    _initializeVideoPlayerFuture = _controller.initialize();
    setState(() {});
  }

  Future<void> _startVideoPlayer(String asset, {bool autoPlay = true}) async {
    if (_controller == null) {
      // If there was no controller, just create a new one
      _initController(asset, autoPlay: autoPlay);
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldController = _controller;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();

        // Initing new controller
        _initController(asset, autoPlay: autoPlay);
      });

      // Making sure that controller is not used by setting it to null

      setState(() {
        _initializeVideoPlayerFuture = null;
        _controller = null;
      });
    }
  }

  @override
  void initState() {
    autoContinue = prefs.getBool('autoContinue') ?? autoContinue;
    musicMuted = prefs.getBool('musicMuted') ?? musicMuted;
    soundMuted = prefs.getBool('soundMuted') ?? soundMuted;

    currentWorkout = workoutPlan.days[0];
    currentCircuitIndex = 0;
    currentExerciseIndex = 0;
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _startVideoPlayer(
        currentWorkout.circuits[currentCircuitIndex]
            .exercises[currentExerciseIndex].clipPath,
        autoPlay: true);
    // _controller = VideoPlayerController.network(
    //   'https://firebasestorage.googleapis.com/v0/b/wwapp-5da9c.appspot.com/o/Banded%20Lateral%20Walk%20-%20Vertical.mp4?alt=media&token=c90b46ba-442e-45eb-97ba-ff27cf93832d',
    // );
//Banded Lateral Walk.mp4

    _wwaTimer = WWATimer(
        controller: _controller,
        totalTime: currentWorkout.exerciseTime,
        autoPlay: true);

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

      if (!(allCompleted() &&
          (currentCircuitIndex == currentWorkout.circuits.length - 1))) {
        var clip = currentWorkout
            .circuits[
                allCompleted() ? currentCircuitIndex + 1 : currentCircuitIndex]
            .exercises[nextIncompletedExecise()]
            .clipPath;
        // _controller.dataSource = 'bicycle_crunches_repeat.mp4'
        _startVideoPlayer(clip);
      }
      rest();
    });

    _wwaRestTimer.addTimeEndListener(() {
      if (autoContinue) {
        _wwaRestTimer.stopTimer();
        isResting = false;
        nextExercise();
      }
    });

    player = AudioPlayer();

    loadMusic();

    playMusic();
    // Fluttertoast.showToast(
    //     msg: "~Music: NEFFEX - Best of Me",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM_RIGHT,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: primaryColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0);

    Wakelock.enable();
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
      Wakelock.disable();
      isCompleted = true;
    });
  }

  @override
  void dispose() {
    Wakelock.disable();
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    player.stop();
    player.dispose();

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
                return _controller == null
                    ? null
                    : AspectRatio(
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
                Positioned(
                  top: 110,
                  right: 35,
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 20,
                    children: [
                      InkWell(
                        onTap: () {
                          if (player.playing) {
                            player.pause();
                            musicMuted = true;
                            prefs.setBool('musicMuted', musicMuted);
                          } else {
                            player.play();
                            musicMuted = false;
                            prefs.setBool('musicMuted', musicMuted);
                          }

                          setState(() {});
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white.withAlpha(160),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 20)
                              ]),
                          child: Icon(
                            !musicMuted ? Icons.music_note : Icons.music_off,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          soundMuted = !soundMuted;
                          prefs.setBool('soundMuted', soundMuted);

                          setState(() {});
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white.withAlpha(160),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 20)
                              ]),
                          child: Icon(
                            !soundMuted ? Icons.volume_up : Icons.volume_off,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                              var clip = currentWorkout
                                  .circuits[currentCircuitIndex]
                                  .exercises[currentExerciseIndex]
                                  .clipPath;
                              _startVideoPlayer(clip, autoPlay: false);
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

                                var clip = currentWorkout
                                    .circuits[currentCircuitIndex]
                                    .exercises[currentExerciseIndex]
                                    .clipPath;
                                _startVideoPlayer(clip, autoPlay: false);
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
            color: Colors.white,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        child: Wrap(
                          direction: Axis.vertical,
                          spacing: -100,
                          children: [
                            Image.asset('assets/images/victory.png'),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(99),
                                    topRight: Radius.circular(99),
                                  )),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      'Add to your Fit Journal',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Wrap(
                                      spacing: 40,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                    'assets/images/journal_media_icon.png'),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Media',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                    'assets/images/journal_thought_icon.png'),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Thought',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                    'assets/images/journal_scale_icon.png'),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Weight',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 60),
                                  RaisedButton(
                                    child: Text(
                                      'HOME',
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

                                      Navigator.pushNamed(
                                        context,
                                        '/home',
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'WELL DONE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'WORKOUT\nCOMPLETED!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Hope to see you tomorrow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withAlpha(150),
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
