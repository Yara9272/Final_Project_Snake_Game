import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MySnakeGame(),
    );
  }
}

class MySnakeGame extends StatefulWidget {
  const MySnakeGame({Key? key}): super(key: key);
  @override
  State<MySnakeGame> createState() => _MySnakeGameState();
}

class _MySnakeGameState extends State<MySnakeGame> {
  List<int> snakePosition = [24,25,26];     //intial snake position
  int foodLocation = Random().nextInt(750); //initial food location, chosen randomly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 760,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 20),
          itemBuilder: (context, index) {
            if (snakePosition.contains(index)) {
              return Container(
                color: Colors.green,
              );
            }
            if (index == foodLocation) {
              return Container(
                color: Colors.red,
              );
            }
            return Container(
              color: Colors.grey[900],
            );
          },
        ),
      ),
    );
  }
}