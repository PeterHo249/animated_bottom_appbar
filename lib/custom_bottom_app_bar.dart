import 'package:custom_bottom_app_bar/notch_clipper.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  final void Function(int) onPressed;
  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundColor;
  final Color backColor;
  final double height;
  final List<IconData> buttonIcons;

  CustomBottomAppBar({
    Key key,
    this.onPressed,
    this.selectedColor,
    this.unselectedColor,
    this.height,
    this.backgroundColor,
    this.backColor,
    this.buttonIcons,
  })  : assert(buttonIcons.length > 2),
        super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar>
    with SingleTickerProviderStateMixin {
  void Function(int) onPressed;
  int currentSelectedIndex;
  Color selectedColor;
  Color unselectedColor;
  Color backgroundColor;
  Color backColor;
  double height;
  List<IconData> buttonIcons;
  int totalStop;
  int lastIndex;
  double lastCenterX;
  double centerX;
  double partitionWidth;
  AnimationController _animationController;
  Tween<double> _tween;
  Animation<double> _animation;
  double distance = 0.0;
  double direction = 1.0;

  void initState() {
    super.initState();
    onPressed = widget.onPressed ?? (int) {};
    height = widget.height ?? 50.0;
    currentSelectedIndex = 0;
    totalStop = widget.buttonIcons.length;
    buttonIcons = widget.buttonIcons;
    lastIndex = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            lastIndex = currentSelectedIndex;
            lastCenterX = centerX;
          }
        },
      );
    _tween = Tween<double>(begin: 0.0, end: 1.0);
    _animation = _tween.animate(_animationController)
      ..addListener(
        () {
          centerX = lastCenterX + distance * _animation.value * direction;
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    if (_animationController == null) {
      _animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedColor = widget.selectedColor ?? Theme.of(context).primaryColor;
    unselectedColor = widget.unselectedColor ?? Theme.of(context).disabledColor;
    partitionWidth = MediaQuery.of(context).size.width / totalStop;
    if (lastCenterX == null && centerX == null) {
      lastCenterX =
          centerX = partitionWidth * currentSelectedIndex + partitionWidth / 2;
    }
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
            buttonIcons,
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
            if (lastIndex == i) {
              return;
            }
            setState(() {
              lastIndex = currentSelectedIndex;
              currentSelectedIndex = i;
              distance =
                  partitionWidth * (currentSelectedIndex - lastIndex).abs();
              direction = currentSelectedIndex > lastIndex ? 1.0 : -1.0;
              _animationController.reset();
              _animationController.forward();
            });
            onPressed(i);
          },
          color:
              i == currentSelectedIndex ? Colors.transparent : unselectedColor,
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
        clipper: NotchClipper(
          totalStop: 3,
          centerX: centerX,
          notchSize: Size(50.0, 50.0),
        ),
        child: Container(
          color: backgroundColor,
        ),
      ),
    );
  }
}
