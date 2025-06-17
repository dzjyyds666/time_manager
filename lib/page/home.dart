import 'package:flutter/material.dart';
import 'package:time_manager/utils/theme.dart';
import 'package:time_manager/widget/timer.dart';

import '../components/menu_item.dart';
import '../utils/logx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  late double _leftWidthRatio;
  int _selectedIndex = 0;
  String _selectedTitle = "首页";
  double _dividerWidth = 2;

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
                decoration: BoxDecoration(color: SystemColors.backgroundColor),
                width: _leftWidthRatio * width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: _leftWidthRatio * width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: null,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {

                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.sunny_snowing),
                      ),
                    ),
                    MenuItem(
                      icon: Icon(Icons.home_filled, color: Colors.amber),
                      text: Text(
                        "首页",
                        style: TextStyle(color: SystemColors.primaryText),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                          _selectedTitle = "首页";
                        });
                      },
                      isSelected: _selectedIndex == 0,
                    ),
                    Menu(
                      title: Text(
                        "随心记",
                        style: TextStyle(color: SystemColors.primaryText),
                      ),
                      items: [
                        MenuItem(
                          icon: Icon(
                            Icons.access_alarm,
                            color: Colors.pinkAccent,
                          ),
                          text: Text(
                            "计时器",
                            style: TextStyle(color: SystemColors.primaryText),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                              _selectedTitle = "计时器";
                            });
                          },
                          isSelected: _selectedIndex == 1,
                        ),
                        MenuItem(
                          icon: Icon(
                            Icons.access_alarm,
                            color: Colors.pinkAccent,
                          ),
                          text: Text(
                            "倒计时",
                            style: TextStyle(color: SystemColors.primaryText),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = 2;
                              _selectedTitle = "倒计时";
                            });
                          },
                          isSelected: _selectedIndex == 2,
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
                    width: _dividerWidth,
                    height: height,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: SystemColors.backgroundColor),
                width: width - (width * _leftWidthRatio) - _dividerWidth,
                height: height,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedTitle,
                            style: TextStyle(
                              fontSize: 20,
                              color: SystemColors.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _getRightContent()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getRightContent() {
    switch (_selectedIndex) {
      case 0:
        return Text("首页");
      case 1:
        return TimerWidget(
          width:
              MediaQuery.of(context).size.width * (1 - _leftWidthRatio) -
              _dividerWidth,
        );
    }
    return Center(
      child: Text(
        "当前页面暂时未找到哦:)",
        style: TextStyle(color: SystemColors.primaryText),
      ),
    );
  }
}
