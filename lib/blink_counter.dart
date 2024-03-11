import 'package:click_on_blinks/cubit/blink_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlinkCounter extends StatefulWidget {
  const BlinkCounter({super.key});

  @override
  State<BlinkCounter> createState() => _BlinkCounterState();
}

class _BlinkCounterState extends State<BlinkCounter> {
  int _isBlinkCount = 0;
  int _isBlinkLeftCount = 0;
  int _isBlinkRightCount = 0;
  double _leftButtonSize = 50.0;
  double _rightButtonSize = 50.0;
  double _middleButtonSize = 50.0;

  Color _leftButtonColor = Colors.blue;
  Color _rightButtonColor = Colors.red;
  Color _middleButtonColor = Colors.green;

  @override
  void initState() {
    super.initState();
    // Listen to blink events

    context.read<BlinkCubit>().stream.listen((state) {
      if (state['isBlinkLeft']! > _isBlinkLeftCount) {
        _animateLeftButton();
        _isBlinkLeftCount = state['isBlinkLeft']!;
      }
      if (state['isBlinkRight']! > _isBlinkRightCount) {
        _animateRightButton();
        _isBlinkRightCount = state['isBlinkRight']!;
      }

      if (state['isBlink']! > _isBlinkCount) {
        _animateMiddleButton();
        _isBlinkCount = state['isBlink']!;
      }
    });
  }

  void _animateLeftButton() {
    setState(() {
      _leftButtonColor = Colors.blue.withOpacity(0.5);
      _leftButtonSize = 100.0;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _leftButtonColor = Colors.blue;
        _leftButtonSize = 50.0;
      });
    });
  }

  void _animateRightButton() {
    setState(() {
      _rightButtonColor = Colors.red.withOpacity(0.5);
      _rightButtonSize = 100.0;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _rightButtonColor = Colors.red;
        _rightButtonSize = 50.0;
      });
    });
  }

  void _animateMiddleButton() {
    setState(() {
      _middleButtonColor = Colors.green.withOpacity(0.5);
      _middleButtonSize = 100.0;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _middleButtonColor = Colors.green;
        _middleButtonSize = 50.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Left Blink Count: $_isBlinkLeftCount'),
            const SizedBox(width: 20.0),
            Text('Right Blink Count: $_isBlinkRightCount'),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _leftButtonSize,
                height: _leftButtonSize,
                color: _leftButtonColor,
                child: const Icon(Icons.arrow_back),
              ),
            ),
            const SizedBox(width: 20.0),
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _middleButtonSize,
                height: _middleButtonSize,
                color: _middleButtonColor,
                child: const Icon(Icons.play_arrow),
              ),
            ),
            const SizedBox(width: 20.0),
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _rightButtonSize,
                height: _rightButtonSize,
                color: _rightButtonColor,
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
