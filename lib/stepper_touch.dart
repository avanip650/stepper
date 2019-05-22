import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class StepperTouch extends StatefulWidget {
  const StepperTouch({
    Key key,
    this.initialValue,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.withSpring = true,
  }) : super(key: key);

  final Axis direction;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final bool withSpring;

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<StepperTouch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  int _value;
  double _startAnimationPosX;
  double _startAnimationPosY;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 0;
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 90.0,
        height: 20.0,
//        width: widget.direction == Axis.horizontal ? 150.0 : 30.0,
//        height: widget.direction == Axis.horizontal ? 30.0 : 150.0,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(40.0),
          color: Colors.white.withOpacity(0.2),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: widget.direction == Axis.horizontal ? 10.0 : null,
                bottom: widget.direction == Axis.horizontal ? null : 10.0,
                child: Icon(Icons.remove, size: 20.0, color: Colors.white),
              ),
              Positioned(
                right: widget.direction == Axis.horizontal ? 10.0 : null,
                top: widget.direction == Axis.horizontal ? null : 10.0,
                child: Icon(Icons.add, size: 20.0, color: Colors.white),
              ),
              GestureDetector(
                onHorizontalDragStart: _onPanStart,
                onHorizontalDragUpdate: _onPanUpdate,
                onHorizontalDragEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 5.0,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              child: child, scale: animation);
                        },
                        child: Text(
                          '$_value',
                          key: ValueKey<int>(_value),
                          style: TextStyle(
                              color: Color(0xFF6D72FF), fontSize: 12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.70) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.70) / box.size.height) - 0.4;
    if (widget.direction == Axis.horizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    bool isHor = widget.direction == Axis.horizontal;
    bool changed = false;
    if (_controller.value <= -0.20) {
      setState(() => isHor ? _value-- : _value++);
      changed = true;
    } else if (_controller.value >= 0.20) {
      setState(() => isHor ? _value++ : _value--);
      changed = true;
    }
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
      new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 100.0,
        ratio: 0.5,
      );
      if (widget.direction == Axis.horizontal) {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
      } else {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed && widget.onChanged != null) {
      widget.onChanged(_value);
    }
  }
}