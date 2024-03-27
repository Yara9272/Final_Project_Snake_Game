// Flutter material library for UI components
import 'package:flutter/material.dart';
// dart math library for generating random numbers
import 'dart:math';
// dart async library for asynchronous programming
import 'dart:async';


void main() {
  runApp(const SnakeGame()); // Entry point of the application, starting the SnakeGame widget
}



class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key}); // Constructor for the SnakeGame widget

  @override
  Widget build(BuildContext context) {
    // Build method for the SnakeGame widget, returning the MaterialApp widget
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MySnakeGame(), // Setting the home screen to MySnakeGame widget
    );
  }
}



class MySnakeGame extends StatefulWidget {
  const MySnakeGame({Key? key}): super(key: key); // Constructor for the MySnakeGame widget
  @override
  State<MySnakeGame> createState() => _MySnakeGameState(); // Creating the state for MySnakeGame
}



enum Direction { up, down, left, right } // Directions the snake can take

// Create a class to hold the calculated values
class GameConfig {
  static int crossAxisCount = 1; // Static variable to hold the count of columns
  static int rowCount = 1; // Static variable to hold the count of rows
}



class _MySnakeGameState extends State<MySnakeGame> {
  List<int> snakePosition = [300, 301, 302]; // Initial position of the snake
  int foodLocation = Random().nextInt(GameConfig.crossAxisCount * GameConfig.rowCount); // Initial food location, chosen randomly
  Direction direction = Direction.right; // Initial direction of the snake


  @override
  void initState() {
    // Initialize method called when the state object is first created
    Timer.periodic(Duration(milliseconds: 200), onGameTick); // Start a timer to call onGameTick method periodically
  }


  void onGameTick(Timer timer) {
    // Method called on each tick of the timer
    updateSnake(); // Update the position of the snake
  }


  @override
  Widget build(BuildContext context) {
    // Calculate the number of squares needed in each dimension
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    GameConfig.crossAxisCount = (screenWidth / 12).ceil(); // Number of squares in the horizontal direction
    GameConfig.rowCount = (screenHeight / 12).ceil(); // Number of squares in the vertical direction
    final int itemCount = GameConfig.crossAxisCount * GameConfig.rowCount; // Total number of squares on the screen

    // Determine the indices of the tip and tail of the snake
    int tipIndex = snakePosition.last; // Index of the tip of the snake
    int tailIndex = snakePosition.first; // Index of the tail of the snake

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          // Gesture detector to handle drag events
          onVerticalDragUpdate: (details) {
            // Update direction based on vertical drag movement
            if (direction != Direction.up && details.delta.dy > 0) {
              direction = Direction.down; // Set direction to down if not already moving up
            }
            if (direction != Direction.down && details.delta.dy < 0) {
              direction = Direction.up; // Set direction to up if not already moving down
            }
          },
          onHorizontalDragUpdate: (details) {
            // Update direction based on horizontal drag movement
            if (direction != Direction.left && details.delta.dx > 0) {
              direction = Direction.right; // Set direction to right if not already moving left
            }
            if (direction != Direction.right && details.delta.dx < 0) {
              direction = Direction.left; // Set direction to left if not already moving right
            }
          },

          child: Container(
            color: Colors.grey[900], // Background color of the container

            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the GridView
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: GameConfig.crossAxisCount, // Number of columns in the GridView
                childAspectRatio: screenWidth / GameConfig.crossAxisCount / screenHeight * GameConfig.rowCount,
                // Aspect ratio of each grid item
              ),

              itemBuilder: (context, index) {
                // Builder function for creating grid items
                if (snakePosition.contains(index)) {
                  // Check if the snake occupies the current grid cell
                  if (index == tipIndex) {
                    // Check if the snake's head is at this index
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: _getTipBorderRadius(), // Apply border radius to snake head
                        color: Colors.green[900], // Color of the snake's head with a darker shade of green
                      ),
                    );
                  } else if (index == tailIndex) {
                    // Check if the snake's tail is at this index
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: _getTailBorderRadius(), // Apply border radius to snake tail
                        color: Colors.green,
                      ),
                    );
                  } else {
                    // Otherwise, render a regular segment of the snake body
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.green,
                      ),
                    );
                  }
                }

                if (index == foodLocation) {
                  // Check if the current grid cell contains food
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  );
                }
                // Render empty grid cells
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Shape of the container
                    color: Colors.grey[900], // Background color of the container
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  // Function to determine border radius for the tip based on direction
  BorderRadius _getTipBorderRadius() {
    switch (direction) {
      case Direction.up:
      // If snake is moving up, give rounded corners to the top
        return BorderRadius.only(
          topLeft: Radius.circular(9.0),
          topRight: Radius.circular(9.0),
        );
      case Direction.down:
      // If snake is moving down, give rounded corners to the bottom
        return BorderRadius.only(
          bottomLeft: Radius.circular(9.0),
          bottomRight: Radius.circular(9.0),
        );
      case Direction.left:
      // If snake is moving left, give rounded corners to the left
        return BorderRadius.only(
          topLeft: Radius.circular(9.0),
          bottomLeft: Radius.circular(9.0),
        );
      case Direction.right:
      // If snake is moving right, give rounded corners to the right
        return BorderRadius.only(
          topRight: Radius.circular(9.0),
          bottomRight: Radius.circular(9.0),
        );
      default:
      // If direction is not recognized, return zero radius
        return BorderRadius.zero;
    }
  }


// Function to determine border radius for the tail based on direction
  BorderRadius _getTailBorderRadius() {
    switch (direction) {
      case Direction.up:
      // If snake is moving up, give rounded corners to the bottom
        return BorderRadius.only(
          bottomLeft: Radius.circular(9.0),
          bottomRight: Radius.circular(9.0),
        );
      case Direction.down:
      // If snake is down up, give rounded corners to the top
        return BorderRadius.only(
          topLeft: Radius.circular(9.0),
          topRight: Radius.circular(9.0),
        );
      case Direction.left:
      // If snake is moving left, give rounded corners to the right
        return BorderRadius.only(
          topRight: Radius.circular(9.0),
          bottomRight: Radius.circular(9.0),
        );
      case Direction.right:
      // If snake is moving right, give rounded corners to the left
        return BorderRadius.only(
          topLeft: Radius.circular(9.0),
          bottomLeft: Radius.circular(9.0),
        );
      default:
        return BorderRadius.zero;
    }
  }


  void updateSnake() {
    setState(() {
      // Determine the current position of the snake's head
      int head = snakePosition.last; // Index of the snake's head

      // Calculate the next position based on the direction
      int nextCell = 0; // Initialize variable to hold the next cell's index
      switch (direction) {
        case Direction.up:
          nextCell = head - GameConfig.crossAxisCount; // Move one row up
          break;
        case Direction.down:
          nextCell = head + GameConfig.crossAxisCount; // Move one row down
          break;
        case Direction.left:
          nextCell = head - 1; // Move one column to the left
          break;
        case Direction.right:
          nextCell = head + 1; // Move one column to the right
          break;
      }

      // Check for collision with food
      if (nextCell == foodLocation) {
        // If the snake eats the food, add a new segment to the snake
        snakePosition.add(nextCell);

        // Generate a new random location for the food
        foodLocation = Random().nextInt(GameConfig.crossAxisCount * GameConfig.rowCount);
      } else {
        // If the snake doesn't eat the food
        // Remove the tail segment of the snake
        snakePosition.removeAt(0);

        // Check for collision with boundaries
        if (nextCell < 0 ||
            nextCell >= GameConfig.crossAxisCount * GameConfig.rowCount || // Check for out-of-bounds condition
            (direction == Direction.left && head % GameConfig.crossAxisCount == 0) || // Check for collision with left wall
            (direction == Direction.right && (head + 1) % GameConfig.crossAxisCount == 0)) { // Check for collision with right wall
          // Game over condition, you may handle it accordingly
          // For now, let's reset the game

          //Reset the game
          // Reset snake's position
          snakePosition = [300, 301, 302];
          // Generate new random food location
          foodLocation = Random().nextInt(GameConfig.crossAxisCount * GameConfig.rowCount);
          // Reset direction to right
          direction = Direction.right;
          return; // Exit the function to prevent further processing
        }

        // Move the snake's head to the next cell
        snakePosition.add(nextCell);
      }
    });
  }
}