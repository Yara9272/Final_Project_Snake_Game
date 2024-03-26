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
  List<int> snakePosition = [300, 301, 302]; //intial snake position
  int foodLocation = Random().nextInt(3000); //initial food location, chosen randomly

  @override
  Widget build(BuildContext context) {
    // Calculate the number of squares needed in each dimension
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final int crossAxisCount = (screenWidth / 12).ceil();
    final int rowCount = (screenHeight / 12).ceil();
    final int itemCount = crossAxisCount * rowCount;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[900], // Background color of the container
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: screenWidth / crossAxisCount / screenHeight *
                  rowCount,
            ),
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
      ),
    );
  }
}