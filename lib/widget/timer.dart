import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/widget/clock_widget.dart';

// 计时器
class TimerWidget extends StatefulWidget {
  final double width;

  TimerWidget({super.key, required this.width});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late double _leftWidthRatio;
  double _dividerWidth = 2;

  @override
  void initState() {
    super.initState();
    _leftWidthRatio = 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width * _leftWidthRatio,
          decoration: BoxDecoration(),
          child: Center(child: ClockWidget(width: widget.width * _leftWidthRatio * 0.5)),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) {
            setState(() {
              _leftWidthRatio += details.delta.dx / widget.width;
              _leftWidthRatio = _leftWidthRatio.clamp(0.4, 0.6);
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Container(width: _dividerWidth, color: Colors.grey.shade400),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.blue),
            width: (1 - _leftWidthRatio) * widget.width - _dividerWidth,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // container 分为上下两部分
                    Container(
                      height: constraints.maxHeight * 0.4, // 内部Container高度为外部Container的50%
                      padding: EdgeInsets.all(16),
                      child: LineChart(LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(1, 1),
                              FlSpot(2, 2),
                              FlSpot(3, 3),
                            ],
                          ),
                        ]
                      )),
                    ),
                    // 可以在这里添加其他组件占用剩余的50%空间
                    Expanded(
                      child: Container(
                        color: Colors.lightBlue,
                        child: Center(
                          child: Text('其他内容区域', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
