import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';


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
// Create a class to hold the calculated values
class GameConfig {
  static int crossAxisCount=1;
  static int rowCount=1;
}


class _MySnakeGameState extends State<MySnakeGame> {
  List<int> snakePosition = [300, 301, 302]; //intial snake position
  int foodLocation = Random().nextInt(GameConfig.crossAxisCount*GameConfig.rowCount); //initial food location, chosen randomly

  Direction direction = Direction.right;




  @override
  void initState(){
    Timer.periodic(Duration(milliseconds: 200),
        onGameTick);
  }


  void onGameTick(Timer timer) {
    updateSnake(); //handle the direction of the snake based on the current direction
  }


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
    GameConfig.crossAxisCount = (screenWidth / 12).ceil();
    GameConfig.rowCount = (screenHeight / 12).ceil();
    final int itemCount = GameConfig.crossAxisCount * GameConfig.rowCount;

    print( GameConfig.crossAxisCount);
    print(GameConfig.rowCount);

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
                crossAxisCount: GameConfig.crossAxisCount,
                childAspectRatio: screenWidth / GameConfig.crossAxisCount / screenHeight *
                    GameConfig.rowCount,
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


  void updateSnake() {
    setState(() {
      // Determine the current position of the snake's head
      int head = snakePosition.last;
      int nextCell = 0;

      // Calculate the next position based on the direction
      switch (direction) {
        case Direction.up:
          nextCell = head - GameConfig.crossAxisCount;
          break;
        case Direction.down:
          nextCell = head + GameConfig.crossAxisCount;
          break;
        case Direction.left:
          nextCell = head - 1;
          break;
        case Direction.right:
          nextCell = head + 1;
          break;
      }

      // Check for collision with food
      if (nextCell == foodLocation) {
        // If the snake eats the food, add a new segment to the snake
        snakePosition.add(nextCell);

        // Generate a new random location for the food
        foodLocation = Random().nextInt(GameConfig.crossAxisCount * GameConfig.rowCount);
      } else {
        // Remove the tail segment of the snake
        snakePosition.removeAt(0);

        // Check for collision with boundaries
        if (nextCell < 0 ||
            nextCell >= GameConfig.crossAxisCount*GameConfig.rowCount || // Assuming a 100x30 grid
            (direction == Direction.left && head % GameConfig.crossAxisCount == 0) || // Hit left wall
            (direction == Direction.right && (head + 1) % GameConfig.crossAxisCount == 0)) {
          // Hit right wall
          // Game over condition, you may handle it accordingly
          // For now, let's reset the game
          snakePosition = [300, 301, 302];
          foodLocation = Random().nextInt(GameConfig.crossAxisCount * GameConfig.rowCount);
          direction = Direction.right; // Reset direction
          return;
        }

        // Move the snake's head to the next cell
        snakePosition.add(nextCell);
      }
    });
  }
}