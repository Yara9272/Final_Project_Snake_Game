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


enum Direction { up, down, left, right }

class _MySnakeGameState extends State<MySnakeGame> {
  List<int> snakePosition = [300, 301, 302]; //intial snake position
  int foodLocation = Random().nextInt(3000); //initial food location, chosen randomly

  Direction direction = Direction.right;

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

    // Determine the indices of the tip and tail of the snake
    int tipIndex = snakePosition.last;
    int tailIndex = snakePosition.first;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (direction != Direction.up && details.delta.dy > 0) {
              direction = Direction.down;
            }
            if (direction != Direction.down && details.delta.dy < 0) {
              direction = Direction.up;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (direction != Direction.left && details.delta.dx > 0) {
              direction = Direction.right;
            }
            if (direction != Direction.right && details.delta.dx < 0) {
              direction = Direction.left;
            }
          },
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
                  // Check if the current index is the tip or tail of the snake
                  if (index == tipIndex){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(9.0), // Round only top right corner
                          bottomRight: Radius.circular(9.0), // Round only bottom right corner
                        ),
                        color: Colors.green[900],
                      ),
                    );
                  } else if (index == tailIndex){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(9.0), // Round only top right corner
                          bottomLeft: Radius.circular(9.0), // Round only bottom right corner
                        ),
                        color: Colors.green,
                      ),
                    );
                  }else{
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.green,
                      ),
                    );
                  }
                }
                if (index == foodLocation) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),                );
                }
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[900],
                  ),              );
              },
            ),
          ),
        ),
      ),
    );
  }
}