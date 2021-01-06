import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:wwa/widgets/wwa_circle_loader_painter.dart';

class WWATimer extends StatefulWidget {
  WWATimer({
    Key key,
    this.controller,
    @required this.totalTime,
  }) : super(key: key);

  final VideoPlayerController controller;
  final int totalTime;
  Function _timerEndListener;
  Function resetTimer;

  @override
  _WWATimerState createState() => _WWATimerState();

  void addTimeEndListener(void Function() listener) {
    this._timerEndListener = listener;
  }
}

class _WWATimerState extends State<WWATimer>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  Animation curve;
  Timer _timer;
  double _time = 0;

  void startTimer() {
    const qSec = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(
      qSec,
      (Timer timer) {
        if (_time < 0.01) {
          setState(() {
            widget.controller.pause();
            rotationController.stop();
            timer.cancel();

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
    _time = widget.totalTime.toDouble();

    widget.resetTimer = (bool autoPlay) {
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
        pauseTimer();
        widget.controller.play();
        rotationController.forward(from: 0.0);
        _time = widget.totalTime.toDouble();
        startTimer();
      },
      onTap: () {
        // Wrap the play or pause in a call to `setState`. This ensures the
        // correct icon is shown.
        setState(() {
          // If the video is playing, pause it.
          if (widget.controller.value.isPlaying) {
            widget.controller.pause();
            rotationController.stop();
            pauseTimer();
          } else {
            // If the video is paused, play it.
            widget.controller.play();
            rotationController.forward(from: rotationController.value);

            startTimer();
          }
        });
      },
      child: Container(
        width: 140,
        height: 100,
        padding: EdgeInsets.only(right: 20, top: 20),
        child: Stack(
          children: [
            Container(
              width: 110,
              height: 50,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '${_time.round()}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                          widget.controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
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
