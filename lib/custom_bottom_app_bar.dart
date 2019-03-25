import 'package:custom_bottom_app_bar/notch_clipper.dart';
import 'package:flutter/material.dart';

/// Animated Bottom Appbar
///
/// [selectedColor] is color of icon when be selected.
/// [unselectedColor] is color of icon when be unselected.
/// [backgroundColor] is background color of appbar.
/// [backColor] should be background color of main view.
/// [buttonIcons] is list of icon to generate button.
/// [onPressed] is callback trigger when a button is pressed.
///
/// All parameters should not be null.
class CustomBottomAppBar extends StatefulWidget {
  final void Function(int) onPressed;
  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundColor;
  final Color backColor;
  final List<IconData> buttonIcons;

  CustomBottomAppBar({
    Key key,
    this.onPressed,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.backColor,
    this.buttonIcons,
  })  : assert(buttonIcons.length >= 2),
        super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar>
    with TickerProviderStateMixin {
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
  Animation<double> _animation;
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  double distance = 0.0;
  double direction = 1.0;
  var notchSize = Size(50.0, 50.0);

  void initState() {
    super.initState();
    onPressed = widget.onPressed ?? (int) {};
    height = 75.0;
    currentSelectedIndex = 0;
    totalStop = widget.buttonIcons.length;
    buttonIcons = widget.buttonIcons;
    lastIndex = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.forward) {
            _iconAnimationController.reverse();
          }
          if (status == AnimationStatus.completed) {
            lastIndex = currentSelectedIndex;
            lastCenterX = centerX;
            _iconAnimationController.forward();
          }
        },
      );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(
            () {
              centerX = lastCenterX + distance * _animation.value * direction;
              setState(() {});
            },
          );

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
    _iconAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_iconAnimationController);
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
          _buildCurrentSelectButton(
              context, buttonIcons[currentSelectedIndex], centerX)
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

    return Column(
      children: <Widget>[
        Container(
          height: notchSize.height / 2,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: buttons,
        ),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: NotchClipper(
          totalStop: 3,
          centerX: centerX,
          notchSize: notchSize,
        ),
        child: Container(
          color: backgroundColor,
        ),
      ),
    );
  }

  Widget _buildCurrentSelectButton(
    BuildContext context,
    IconData icon,
    double centerX,
  ) {
    var positionRect = Rect.fromLTWH(
      centerX - notchSize.width / 2,
      0,
      notchSize.width,
      notchSize.height,
    );

    return Positioned.fromRect(
      rect: positionRect,
      child: FloatingActionButton(
        child: ScaleTransition(
          scale: _iconAnimation,
          child: Icon(
            icon,
            size: 30.0,
            color: selectedColor,
          ),
        ),
        backgroundColor: backgroundColor,
        onPressed: null,
      ),
    );
  }
}
