import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  final double width;

  ClockWidget({super.key, required this.width});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  ClockState _state = ClockState.stop;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.width,
          height: widget.width,
          child: Text("时钟"),
          decoration: BoxDecoration(color: Colors.white),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [for (var item in _getClickButton()) item],
        ),
      ],
    );
  }

  List<Widget> _getClickButton() {
    if (_state == ClockState.stop) {
      return [playButton];
    }else if (_state == ClockState.play) {
      return [pauseButton, stopButton];
    }else if (_state == ClockState.pause) {
      return [playButton, stopButton];
    }
    return [];
  }

  get playButton => GestureDetector(
    onTap: () {
      setState(() {
        _state = ClockState.play;
      });
    },
    child: Container(
      padding: EdgeInsets.all(20),
      child: Icon(Icons.play_circle,size: 40,),
    ),
  );

  get pauseButton => GestureDetector(
    onTap: () {
      setState(() {
        _state = ClockState.pause;
      });
    },
    child: Container(
      padding: EdgeInsets.all(20),
      child: Icon(Icons.pause_circle,size: 40,),
    ),
  );

  get stopButton => GestureDetector(
    onTap: () {
      setState(() {
        _state = ClockState.stop;
      });
    },
    child: Container(
      padding: EdgeInsets.all(20),
      child: Icon(Icons.stop_circle,size: 40,),
    ),
  );
}

enum ClockState { play, pause, stop }
