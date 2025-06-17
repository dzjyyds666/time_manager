import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  Text title;
  List<MenuItem> items;

  Menu({super.key, required this.items, required this.title});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [widget.title, for (var item in widget.items) item],
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  Icon icon;
  Text text;

  MenuItem({super.key, required this.icon, required this.text});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  int action = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          action = 1;
        });
      },
      child: Container(
        decoration: BoxDecoration(color: _getItemColor()),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(children: [widget.icon, widget.text]),
      ),
    );
  }

  Color _getItemColor() {
    if (action == 0) {
      return Colors.white;
    } else if (action == 1) {
      return Colors.grey.shade300;
    }
    return Colors.grey;
  }
}
