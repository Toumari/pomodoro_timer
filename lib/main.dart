import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_timer/widget/button_widget.dart';
import 'package:audioplayers/audioplayers.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(child: TimerApp()),
      ),
    );
  }
}

String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final minutes = duration.inMinutes;
  final seconds = totalSeconds % 60;

  final minutesString = '$minutes'.padLeft(2, '0');
  final secondsString = '$seconds'.padLeft(2, '0');
  return '$minutesString:$secondsString';
}

class TimerApp extends StatefulWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  static AudioCache player = AudioCache();

  Widget buildTime() {
    return Text(
      '${formatDuration(seconds)}',
      style: TextStyle(
          color: Colors.white, fontSize: 60.0, fontWeight: FontWeight.bold),
    );
  }

  int maxSeconds = 900;

  @override
  void initState() {
    super.initState();
    seconds = 900;
  }

  late int seconds;
  int newSeconds = 0;
  Timer? timer;

  Widget buildButtons() {
    var isRunning = timer == null ? false : timer!.isActive;
    var isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                      text: isRunning ? 'Pause' : 'Resume',
                      onClicked: () {
                        if (isRunning) {
                          stopTimer(reset: false);
                        } else {
                          startTimer(reset: false, secondsToRun: maxSeconds);
                        }
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  ButtonWidget(
                      text: 'Cancel',
                      onClicked: () {
                        stopTimer(reset: true);
                      }),
                ],
              ),
            ],
          )
        : Column(
            children: [
              ButtonWidget(
                  text: 'Start Timer',
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  onClicked: () {
                    startTimer(secondsToRun: maxSeconds);
                  }),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonWidget(
                      text: '15 Minutes',
                      color: Colors.white,
                      backgroundColor: Colors.teal,
                      onClicked: () {
                        setState(() {
                          stopTimer(reset: true);
                          seconds = 900;
                          maxSeconds = seconds;
                          isRunning = false;
                          isCompleted = true;
                        });
                        print(seconds);
                      }),
                  ButtonWidget(
                      text: '30 Minutes',
                      color: Colors.white,
                      backgroundColor: Colors.teal,
                      onClicked: () {
                        stopTimer(reset: true);
                        seconds = 1800;
                        maxSeconds = seconds;
                        isRunning = false;
                        isCompleted = true;
                      }),
                  ButtonWidget(
                      text: '60 Minutes',
                      color: Colors.white,
                      backgroundColor: Colors.teal,
                      onClicked: () {
                        stopTimer(reset: true);
                        seconds = 3600;
                        maxSeconds = seconds;
                        isRunning = false;
                        isCompleted = true;
                      }),
                ],
              )
            ],
          );
  }

  Widget buildTimer() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(fit: StackFit.expand, children: [
        CircularProgressIndicator(
          strokeWidth: 12,
          backgroundColor: Colors.tealAccent,
          valueColor: AlwaysStoppedAnimation(Colors.teal),
          value: seconds / maxSeconds,
        ),
        Center(
          child: buildTime(),
        ),
      ]),
    );
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    setState(() {
      timer?.cancel();
    });
  }

  void startTimer({bool reset = true, required int secondsToRun}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      print('decreasing');
      print(seconds);
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        player.play('sound2.wav');
        stopTimer(reset: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Pomodoro Timer',
          style: TextStyle(
              fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimer(),
              SizedBox(
                height: 100,
              ),
              buildButtons(),
            ],
          ),
        ),
      ],
    );
  }
}
