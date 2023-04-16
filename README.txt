# mips-dots-and-boxes
The dots and boxes game written in MIPS assembly language

The game will be an 6x8 ascii board such as the one below

Without Lines
   1   2   3   4   5   6   7   8
1  +   +   +   +   +   +   +   +

2  +   +   +   +   +   +   +   +

3  +   +   +   +   +   +   +   +

4  +   +   +   +   +   +   +   +

5  +   +   +   +   +   +   +   +

6  +   +   +   +   +   +   +   +

With Lines
   1   2   3   4   5   6   7   8
1  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
2  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
3  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
4  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
5  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
6  +---+---+---+---+---+---+---+

The user will input two sets of x,y coordinates like "4 5" and a cardinal direction and if that line has not already been drawn it will be added.

Lines will be stored in two sets of arrays, one for horizontal lines and one for vertical lines.

# Organization
   Main: Used for getting inputs and outputs
   
   Line adding: Used for adding specific 
   
   Scoring: Keeps track of turn order and checks / updates score
   
   
