import 'package:flutter/material.dart';
import 'package:time_manager/utils/theme.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: widget.title,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(color: Colors.grey.shade300),
          ),
        ),
        for (var item in widget.items) item,
      ],
    );
  }
}

class MenuItem extends StatefulWidget {
  final Icon icon;
  final Text text;
  final Function() onTap;
  final bool isSelected;

  MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  int action = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            color:
                widget.isSelected
                    ? Colors.grey.shade300
                    : SystemColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(children: [widget.icon, SizedBox(width: 3), widget.text]),
        ),
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
