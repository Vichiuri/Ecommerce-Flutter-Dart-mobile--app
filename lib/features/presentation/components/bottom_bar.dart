import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({
    required this.iconData,
    required this.text,
    this.badget,
    this.qty,
  });
  IconData iconData;
  String text;
  bool? badget;
  int? qty;
}

//custom bottom bar with notch
class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    required this.items,
    this.centerItemText,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    required this.color,
    required this.selectedColor,
    this.notchedShape,
    required this.onTabSelected,
    this.currentIndex,
    this.onBackButtonPressed,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int> onTabSelected;
  final int? currentIndex;
  final ValueChanged<int>? onBackButtonPressed;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex ?? 0;
  }

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didUpdateWidget(covariant FABBottomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      print("widget updated");
    } else {
      print("widget not updated");
      _selectedIndex = widget.currentIndex ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    // String _text = _selectedIndex == index ? item.text : "";
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Icon(item.iconData, color: color, size: widget.iconSize),
                    item.badget != null && item.badget!
                        ? Positioned(
                            right: 0.0,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: item.qty == 0
                                    ? Colors.transparent
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 13,
                                minHeight: 13,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Text(
                                  item.qty == 0 ? "" : "${item.qty}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Opacity(opacity: 0),
                  ],
                ),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
