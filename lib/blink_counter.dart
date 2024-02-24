import 'package:click_on_blinks/cubit/blink_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlinkCounter extends StatelessWidget {
  const BlinkCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlinkCubit, int>(
      builder: (context, blinkCount) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Blink Count:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$blinkCount',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}
