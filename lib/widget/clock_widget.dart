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
              width: widget.width + 20,
              height: widget.width + 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2),
                  bottom: BorderSide(color: Colors.black, width: 2),
                  left: BorderSide(color: Colors.black, width: 2),
                  right: BorderSide(color: Colors.black, width: 2),
                ),
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
                isActive: _state == ClockState.play,
                isReset: _state == ClockState.stop,
              ),
            ),
            Text(
              utils.timeFormat(_count),
              style: TextStyle(fontSize: widget.width * 0.1),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [for (var item in _getClickButton()) item],
        ),
      ],
    );
  }

  // 开始定时器
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
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
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      child: Icon(Icons.play_arrow, size: widget.width * 0.1),
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
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      child: Icon(Icons.pause, size: widget.width * 0.1),
    ),
  );

  get stopButton => GestureDetector(
    onTap: () {
      setState(() {
        _state = ClockState.pause;
      });
      _showStopDialog();
      _pauseTimer();
    },
    child: Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      child: Icon(Icons.stop, size: widget.width * 0.1),
    ),
  );

  // 弹出停止弹窗
  void _showStopDialog() { 
    showDialog(context: context, builder: (builder){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("停止计时"),
        content: Text("是否停止本次计时呢？"),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Text('取消')),
          IconButton(onPressed: (){
            setState(() {
              _state = ClockState.stop;
              _count = 0;
            });
            // todo 记录本次数据到数据库
            Navigator.of(context).pop();
          }, icon: Text('确定'))
        ],
      );
    });
  }
}

enum ClockState { play, pause, stop }
