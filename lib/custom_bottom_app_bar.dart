import 'package:custom_bottom_app_bar/notch_clipper.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  final void Function(int) onPressed;
  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundColor;
  final Color backColor;
  final double height;

  CustomBottomAppBar({
    Key key,
    this.onPressed,
    this.selectedColor,
    this.unselectedColor,
    this.height,
    this.backgroundColor,
    this.backColor,
  }) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  void Function(int) onPressed;
  int currentSelectedIndex;
  Color selectedColor;
  Color unselectedColor;
  Color backgroundColor;
  Color backColor;
  double height;

  void initState() {
    super.initState();
    onPressed = widget.onPressed ?? (int) {};
    height = widget.height ?? 50.0;
    currentSelectedIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedColor = widget.selectedColor ?? Theme.of(context).primaryColor;
    unselectedColor = widget.unselectedColor ?? Theme.of(context).disabledColor;
    backgroundColor =
        widget.backgroundColor ?? Theme.of(context).bottomAppBarColor;
    backColor = widget.backColor ?? Colors.white;
    return Container(
      color: backColor,
      height: height,
      child: Stack(
        children: [
          _buildBackground(context),
          _buildButtonList(
            context,
            [
              Icons.menu,
              Icons.person_outline,
              Icons.add_circle_outline,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonList(BuildContext context, List<IconData> buttonIcons) {
    if (buttonIcons.length < 2) {
      return Container();
    }

    List<Widget> buttons = [];
    for (int i = 0; i < buttonIcons.length; i++) {
      buttons.add(
        IconButton(
          onPressed: () {
            setState(() {
              currentSelectedIndex = i;
            });
            onPressed(i);
          },
          color: i == currentSelectedIndex ? Colors.transparent : unselectedColor,
          icon: Icon(buttonIcons[i]),
          iconSize: 30.0,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttons,
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: NotchClipper(totalStop: 3, position: currentSelectedIndex + 1, notchSize: Size(50.0, 50.0)),
        child: Container(
          color: backgroundColor,
        ),
      ),
    );
  }
}
