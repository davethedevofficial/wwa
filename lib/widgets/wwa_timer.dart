import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:wwa/widgets/wwa_circle_loader_painter.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:wwa/helpers/data.dart';

class WWATimer extends StatefulWidget {
  WWATimer({
    Key key,
    this.controller,
    @required this.totalTime,
    this.autoPlay = false,
    this.onPause,
    this.onPlay,
  }) : super(key: key);

  VideoPlayerController controller;
  final int totalTime;
  Function _timerEndListener;
  Function resetTimer;
  Function onPause;
  Function onPlay;
  bool autoPlay;

  @override
  _WWATimerState createState() => _WWATimerState();

  void addTimeEndListener(void Function() listener) {
    this._timerEndListener = listener;
  }

  void setController(c) {
    // controller.dispose();
    controller = c;
  }
}

class _WWATimerState extends State<WWATimer>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  Animation curve;
  Timer _timer;
  double _time = 0;
  Timer _prepTimer;
  double _prepTime = 3;
  bool _autoPlay = false;
  Soundpool pool;
  int doneSoundId;
  int setSoundId;
  int goSoundId;

  loadSounds() async {
    doneSoundId = await rootBundle
        .load('assets/audios/beep1.mp3')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    setSoundId = await rootBundle
        .load('assets/audios/beep2.mp3')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    goSoundId = await rootBundle
        .load('assets/audios/beep3.mp3')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  playSound(int id) {
    pool.play(id);
  }

  String getPrepMessage() {
    if (_prepTime < 1.1) return 'BEGIN!';
    if (_prepTime < 2.1) return 'SET!';
    if (_prepTime < 3.1) return 'GET READY!';

    return '';
  }

  void startPrepTimer() {
    const qSec = const Duration(milliseconds: 100);
    _prepTimer = new Timer.periodic(
      qSec,
      (Timer timer) {
        if (_prepTime < 0.01) {
          setState(() {
            startTimer();
            timer.cancel();
          });
        } else {
          if (prefs.getBool('soundMuted') == null ||
              !prefs.getBool('soundMuted')) {
            if (_prepTime == 3) playSound(setSoundId);
            if (_prepTime.toStringAsFixed(1) == '2.1') playSound(setSoundId);
            if (_prepTime.toStringAsFixed(1) == '1.1') playSound(goSoundId);
          }
          setState(() {
            _prepTime -= 0.1;
          });
        }
      },
    );
  }

  void startTimer() {
    if (_prepTime > 0) {
      return startPrepTimer();
    }

    const qSec = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(
      qSec,
      (Timer timer) {
        if (_time < 0.01) {
          setState(() {
            widget.controller.pause();
            rotationController.stop();
            timer.cancel();

            if (prefs.getBool('soundMuted') == null ||
                !prefs.getBool('soundMuted')) playSound(doneSoundId);
            if (widget._timerEndListener != null) widget._timerEndListener();
          });
        } else {
          setState(() {
            _time -= 0.1;
          });
        }
      },
    );
  }

  void pauseTimer() {
    if (_timer != null) _timer.cancel();
    _timer = null;
  }

  @override
  void initState() {
    pool = Soundpool(streamType: StreamType.music, maxStreams: 3);
    loadSounds();

    _time = widget.totalTime.toDouble();
    _prepTime = 3;

    widget.resetTimer = (bool autoPlay) {
      _autoPlay = autoPlay;
      _prepTime = 3;
      if (_prepTimer != null) _prepTimer.cancel();
      _time = widget.totalTime.toDouble();
      pauseTimer();

      if (autoPlay) {
        startTimer();
        rotationController.forward(from: 0.0);
      } else {
        widget.controller.pause();
        rotationController.stop();
        setState(() {});
      }
    };

    rotationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    curve = CurvedAnimation(
        parent: rotationController, curve: Curves.easeInOutCubic);

    rotationController.addStatusListener((s) {
      if (widget.controller.value.isPlaying && s == AnimationStatus.completed) {
        rotationController.repeat(reverse: false);
      }
    });

    if (widget.autoPlay) widget.resetTimer(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    rotationController.dispose();

    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        if (_prepTime > 0 && _autoPlay) return;

        _autoPlay = true;
        pauseTimer();
        widget.controller.play();
        rotationController.forward(from: 0.0);
        _time = widget.totalTime.toDouble();
        startTimer();
      },
      onTap: () {
        if (_prepTime > 0 && _autoPlay) return;

        _autoPlay = true;
        // Wrap the play or pause in a call to `setState`. This ensures the
        // correct icon is shown.
        setState(() {
          // If the video is playing, pause it.
          if (widget.controller.value.isPlaying) {
            widget.controller.pause();
            rotationController.stop();
            if (widget.onPause != null) widget.onPause();
            pauseTimer();
          } else {
            // If the video is paused, play it.
            widget.controller.play();
            rotationController.forward(from: rotationController.value);
            if (widget.onPause != null) widget.onPlay();
            startTimer();
          }
        });
      },
      child: Container(
        width: 280,
        height: 100,
        padding: EdgeInsets.only(right: 20, top: 20),
        child: Stack(
          children: [
            Positioned(
              right: 40,
              child: Container(
                width: _prepTime < 0.1 ? null : 200,
                height: 50,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(99),
                      bottomLeft: Radius.circular(99)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40, left: 20),
                    child: Text(
                      _prepTime < 0.1 ? '${_time.round()}' : getPrepMessage(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _prepTime < 0.1 ? 20 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Colors.white,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      RotationTransition(
                        alignment: Alignment.center,
                        turns: Tween(begin: 0.0, end: 1.0).animate(curve),
                        child: SvgPicture.asset('assets/images/flash.svg'),
                      ),
                      Center(
                        child: Icon(
                          (_prepTime < 0.1 || !_autoPlay)
                              ? (widget.controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow)
                              : Icons.pan_tool,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          color: Colors.transparent,
                          child: CustomPaint(
                            painter: WWACircleLoaderPainter(
                                (widget.totalTime - _time) / widget.totalTime),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
