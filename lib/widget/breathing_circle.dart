import 'dart:math';

import 'package:flutter/material.dart';

class BreathingCircle extends StatefulWidget {
  final int dotCount; // 圆点数量
  final double baseRadius; // 圆点默认半径
  final double activeRadius; // 圆点最大半径
  final double circleRadius; // 圆点分布的最大半径
  final bool isActive; // 是否激活
  final bool isReset; // 是否重置 

  BreathingCircle({
    super.key,
    required this.dotCount,
    required this.baseRadius,
    required this.activeRadius,
    required this.circleRadius,
    this.isActive = true, 
    this.isReset = false,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // 动画控制器

  @override
  void initState() {
    super.initState();
    // 在initState中初始化动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.dotCount),
    );
    
    // 处理初始状态
    if (widget.isReset) {
      // 如果是重置状态，确保动画控制器被重置
      _controller.reset();
    } else if (widget.isActive) {
      // 如果是激活状态且不是重置状态，开始动画
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 销毁动画控制器，避免内存泄露
    super.dispose();
  }
  
  @override
  void didUpdateWidget(BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当widget的isActive或isReset属性变化时更新动画状态
    if (widget.isActive != oldWidget.isActive || widget.isReset != oldWidget.isReset) {
      if (widget.isReset) {
        // 如果切换到重置状态，立即重置动画控制器
        _controller.reset();
      } else if (widget.isActive) {
        // 如果切换到激活状态且不是重置状态，开始动画
        _controller.repeat();
      } else {
        // 如果既不是激活状态也不是重置状态，停止动画
        _controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return CustomPaint(
          size: Size.square(100),
          painter: _DotPainter(
            progress: _controller.value,
            // 动画进度 [0.0 ~ 1.0]
            dotCount: widget.dotCount,
            baseRadius: widget.baseRadius,
            activeRadius: widget.activeRadius,
            circleRadius: widget.circleRadius,
            isReset: widget.isReset,
          ),
        );
      },
    );
  }
}

// 自定义画笔类，绘制圆圈上的多个点
class _DotPainter extends CustomPainter {
  final double progress; // 当前动画的进度（0 到 1）
  final int dotCount; // 点的数量
  final double baseRadius; // 默认点大小
  final double activeRadius; // 活动点最大大小
  final double circleRadius; // 圆点分布的半径
  final bool isReset; // 是否重置所有点为最小尺寸

  _DotPainter({
    required this.progress,
    required this.dotCount,
    required this.baseRadius,
    required this.activeRadius,
    required this.circleRadius,
    this.isReset = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final angleStep = 2 * pi / dotCount;

    // 当前激活的点索引
    int activeIndex = (progress * dotCount).floor() % dotCount;
    // 当前激活动画进度（用于呼吸动画）
    double localProgress = (progress * dotCount) % 1;

    for (int i = 0; i < dotCount; i++) {
      final angle = -pi / 2 + i * angleStep;
      final dx = center.dx + circleRadius * cos(angle);
      final dy = center.dy + circleRadius * sin(angle);

      // 如果是重置状态，所有点都显示为最小尺寸
      double radius;
      if (isReset) {
        // 重置状态下，确保所有点都是最小尺寸
        radius = baseRadius;
      } else if (i == activeIndex) {
        // 使用sin函数来实现呼吸效果（0 -> 1 -> 0）
        double breath = sin(localProgress * pi);
        radius = baseRadius + (activeRadius - baseRadius) * breath;
      } else {
        radius = baseRadius;
      }

      final paint = Paint()..color = Colors.blue;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }
  // 每一帧都需要重绘
  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) => true;
}
