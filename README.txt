# mips-dots-and-boxes
The dots and boxes game written in MIPS assembly language

The game will be an 6x8 ascii board such as the one below

Without Lines
   0   1   2   3   4   5   6   7
0  +   +   +   +   +   +   +   +

1  +   +   +   +   +   +   +   +

2  +   +   +   +   +   +   +   +

3  +   +   +   +   +   +   +   +

4  +   +   +   +   +   +   +   +

5  +   +   +   +   +   +   +   +

With Lines
   0   1   2   3   4   5   6   7
0  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
1  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
2  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
3  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
4  +---+---+---+---+---+---+---+
   |   |   |   |   |   |   |   |
5  +---+---+---+---+---+---+---+

The user will input two sets of x,y coordinates like "4 5" and a cardinal direction and if that line has not already been drawn it will be added.

Lines will be stored in two sets of arrays, one for horizontal lines and one for vertical lines.

# Organization
   Data: Arrays and ascii representations as well as scoring and winning condition text
      Pseudocode:
                  Instantiate byte array horiArr size 42
                  Instantiate byte array vertArr size 40
                  Instantiate byte array boxArr size 35
                  Instantiate String hori = "---"
                  Instantiate String vert ="|"
                  Instantiate String dot = "+"
                  Instanitate String newLine = "\n"
                  Instanitate String p1 = "Player 1 "
                  Instanitate String p2 = "Player 2 "
                  Instantiate String score = "score is "
                  Instantiate String win = "wins!"
                  
   Main: Used for getting inputs and organizing
      Pseudocode:
      
   Line adding: Used for adding specific 
      Pseudocode:
         
   Box Counter: counts the number of boxes in the grid
      Pseudocode:
         integer i = 0
         integer j = 0
         while i < 5
            while j < 7
               if horiArr[i*8 + j] == 1 and horiArr[(i+1)*8 + j] == 1 and vertArr[i*9 + j] == 1 and vertArr[i*9 + j + 1] == 1 and box[i*7 + j] == 0
                  box[i*7 + j] = turnNumber
               j = j + 1
            i = i + 1
                  
   Scoring: Keeps track of turn order and checks / updates score
      Pseudocode:
   
