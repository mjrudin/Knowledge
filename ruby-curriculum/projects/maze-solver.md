# Maze solver

In this exercise, we want to write a program that will find a route
between two points in a maze.

Here's an example [maze][maze1]. It has an 'S' for the start point,
and an 'E' for an end point.

[maze1]: mazes/maze1.txt

You should write a program that will read in the maze, try to explore
a path through it to the end, and then prints out a completed path
[like so][maze1-soln]. If there is no such path, it should inform the
user.

Make your program run as a command line script, taking in the name of
a maze file on the command line.

[maze1-soln]: mazes/maze1-soln.txt

Your path through the maze should not be self-intersecting, of course.

When you have found a first solution, write a version which will be
sure to find the *shortest path* through the maze.


## Resources
* Reading Files [progzoo]
* Simple-ish explanation for computer pathfinding, start at "Starting the Search" heading [policyalmanac]
* Wikipedia: maze shortest path [wikipedia]

[pathfinding]: http://theory.stanford.edu/~amitp/GameProgramming/AStarComparison.html
[progzoo]: http://progzoo.net/wiki/Ruby:Read_a_Text_File
[policyalmanac]: http://www.policyalmanac.org/games/aStarTutorial.htm
[wikipedia]: http://en.wikipedia.org/wiki/Maze_solving_algorithm#Shortest_path_algorithm
