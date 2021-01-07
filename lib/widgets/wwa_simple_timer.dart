import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wwa/widgets/wwa_circle_loader_painter.dart';

class WWASimpleTimer extends StatefulWidget {
  int totalTime;
  Function resetTimer;
  Function stopTimer;
  Function _timerEndListener;

  WWASimpleTimer({
    Key key,
    @required this.totalTime,
  }) : super(key: key);

  @override
  _WWASimpleTimerState createState() => _WWASimpleTimerState();

  void addTimeEndListener(void Function() listener) {
    this._timerEndListener = listener;
  }
}

class _WWASimpleTimerState extends State<WWASimpleTimer>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  Animation curve;
  Timer _timer;
  double _time = 0;

  void startTimer() {
    const qSec = const Duration(milliseconds: 100);
    rotationController.forward(from: 0.0);
    _timer = new Timer.periodic(
      qSec,
      (Timer timer) {
        if (_time < 0.01) {
          setState(() {
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
      startTimer();
    };

    widget.stopTimer = () {
      pauseTimer();
    };

    rotationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    curve = CurvedAnimation(
        parent: rotationController, curve: Curves.easeInOutCubic);

    rotationController.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        rotationController.repeat(reverse: false);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    rotationController.dispose();

    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: RotationTransition(
                alignment: Alignment.center,
                turns: Tween(begin: 0.0, end: 1.0).animate(curve),
                child: SvgPicture.asset('assets/images/flash_white.svg'),
              ),
            ),
          ),
          Center(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                  color: Colors.white.withAlpha(100),
                ),
              ),
              child: CustomPaint(
                painter: WWACircleLoaderPainter(
                    (widget.totalTime - _time) / widget.totalTime,
                    color: Colors.white),
              ),
            ),
          ),
          Center(
            child: Text(
              '${_time.round()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
