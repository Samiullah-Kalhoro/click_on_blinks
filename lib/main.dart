import 'package:click_on_blinks/blink_counter.dart';
import 'package:click_on_blinks/cubit/blink_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Blink Counter'),
        ),
        body: Center(
          child: BlocProvider(
            create: (context) => BlinkCubit(),
            child: const BlinkCounter(),
          ),
        ),
      ),
    );
  }
}
