import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:time_manager/utils/common.dart';
import 'package:time_manager/widget/breathing_circle.dart';

class ClockWidget extends StatefulWidget {
  final double width;

  ClockWidget({super.key, required this.width});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  ClockState _state = ClockState.stop;
  int _count = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center, //  整个 Stack 内容居中
          children: [
            Container(
              width: widget.width,
              height: widget.width,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: widget.width,
              height: widget.width,
              child: BreathingCircle(
                dotCount: 12,
                baseRadius: widget.width * 0.02,
                activeRadius: widget.width * 0.04,
                circleRadius: widget.width / 2 - 10, //  注意减点 padding 避免溢出
              ),
            ),
            Text(utils.timeFormat(_count), style: TextStyle(fontSize: widget.width * 0.1)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [for (var item in _getClickButton()) item],
        ),
      ],
    );
  }

  // 开始定时器
  void _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (_timer){
        setState(() {
          _count++;
        });
      });
  }

  // 暂停定时器
  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  List<Widget> _getClickButton() {
    if (_state == ClockState.stop) {
      return [playButton];
    } else if (_state == ClockState.play) {
      return [pauseButton, stopButton];
    } else if (_state == ClockState.pause) {
      return [playButton, stopButton];
    }
    return [];
  }

  get playButton => GestureDetector(
    onTap: () async {
      setState(() {
        _state = ClockState.play;
      });
      _startTimer();
    },
    child: Container(
      padding: EdgeInsets.all(20),
      child: Icon(Icons.play_circle, size: 40),
    ),
  );

  get pauseButton => GestureDetector(
    onTap: () async {
      setState(() {
        _state = ClockState.pause;
      });
      _pauseTimer();
    },
    child: Container(
      padding: EdgeInsets.all(20),
      child: Icon(Icons.pause_circle, size: 40),
    ),
  );

  get stopButton => GestureDetector(
    onTap: () {
      setState(() {
        _state = ClockState.stop;
      });
      _pauseTimer();
    },
    child: Container(
      padding: EdgeInsets.all(20),
      child: Icon(Icons.stop_circle, size: 40),
    ),
  );
}

enum ClockState { play, pause, stop }
