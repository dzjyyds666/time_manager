import 'package:flutter/material.dart';
import 'package:time_manager/utils/theme.dart';

import '../components/menu_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  late double _leftWidthRatio;

  @override
  void initState() {
    super.initState();
    _leftWidthRatio = 0.2;
  }

  @override
  Widget build(BuildContext context) {
    // 两部分，左边菜单，右边内容
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      builder: (context, child) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                decoration: BoxDecoration(color: SystemColors.primary),
                width: _leftWidthRatio * width,
                height: height,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: _leftWidthRatio * width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(children: []),
                    ),
                    Menu(
                      title: Text("随心记"),
                      items: [
                        MenuItem(
                          icon: Icon(Icons.access_alarm),
                          text: Text("计时器"),
                        ),
                        MenuItem(
                          icon: Icon(Icons.access_alarm),
                          text: Text("倒计时"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _leftWidthRatio += details.delta.dx / width;
                    _leftWidthRatio = _leftWidthRatio.clamp(0.2, 0.3);
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: Container(
                    width: 4,
                    height: height,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: SystemColors.primary),
                width: width - (width * _leftWidthRatio) - 4,
                height: height,
              ),
            ],
          ),
        );
      },
    );
  }
}
