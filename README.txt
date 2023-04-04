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

The user will input two sets of x,y coordinates like "4 5 4 6" and if that line has not already been drawn it will be added.
At each coordinate point will be stored a 2 bit number. The first bit will represent whether it is in a line and the second will represent if it has been scored.
For example: 01 is in a line but not scored, 00 is not in a line and has not been scored, 10 is invalid, and 11 has been scored and is in a line.
If they are both already 01 or 11 then ask for a different coordinate. Just one having a 01 or 11 is okay.

Then the system will run a check along the entire 2D array so see if there is a new box
Proposed Solution: Nested for loop from i: 1-5, j: 1-7, sum the values of (i,j), (i,j+1), (i+1, j+1), (i+1, j) to a 
                   4 bit number
                   Then check if it is less than 12, if so then change all the values to 11 and score a point to whoever's 
                   turn it is.
                   If not then the program will not add anything and move on
