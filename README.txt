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
                  Instantiate String error = "Error in input, try again"
                  
   Main: Used for getting inputs and organizing
      Pseudocode:
      player = 1
      lines = 0
      loop:
      print game screen
      get int input x
      get int input y
      get dir input N/S/E/W, replace with int 1/2/3/4
      call add line x, y, dir, player
      lines = lines + 1
      player = 3 - player
      bne lines, 7*6 + 8*5, loop
      print end screen
      
   Line adding: Used for adding specific 
      Pseudocode:
         get row coordinate = x
         get col coordinate = y
         get direction (NESW) = dir
         if dir == 0 and x > 0 # North
            if vertArr[(x-1)*8 + y] == 1
               jump to input error
            vertArr[(x-1)*8 + y] = 1
         else if dir == 1 and y < 7 # East
            if horiArr[(x)*8 + y + 1] == 1
               jump to input error
            horiArr[(x)*8 + y + 1] = 1
         else if dir == 2 and x < 5 # South
            if vertArr[(x)*8 + y] == 1
               jump to inputError
            vertArr[(x)*8 + y] = 1
         else if dir == 3 and y > 0 # West
            if horiArr[(x)*8 + y] == 1
               jump to inputError
            horiArr[(x)*8 + y] = 1
         else # if none go through the input is in error
            jump to inputError
         jump to box counter file
         inputError: print error 
                     print newLine
                     jump to main
                     
   Box Counter: counts the number of boxes in the grid
      Pseudocode:
         int i = 0
         int j = 0
         get score
         while i < 5
            while j < 7
               if horiArr[i*8 + j] == 1 and horiArr[(i+1)*8 + j] == 1 and vertArr[i*9 + j] == 1 and vertArr[i*9 + j + 1] == 1 and box[i*7 + j] == 0
                  box[i*7 + j] = turnNumber
                  score[turnNumber] = score[turnNumber + 1]
               j = j + 1
            i = i + 1
            j = 0
                  
   Scoring: Keeps track of turn order and checks / updates score
   Not needed, turn order in main, score update in add lines.
   
   print end screen:
   get score
   slt score[1], score[2], check
   print "player "
   print check + 1
   print " wins"
   
