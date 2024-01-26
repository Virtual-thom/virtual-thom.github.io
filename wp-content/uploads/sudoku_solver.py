  # ex. and explain the context
  # let's take a value n = 3 we want to check if possible on coordinates (x,y) = (5, 1)
  #     
  # grid = [
  #   [ b, c, a, a, a, a, a, a, a ],
  #   [ a, d, a, a, a, s, a, a, a ],
  #   [ a, a, a, a, a, a, a, a, a ],
  #   ....
  # ]
  # so if we look at a sudoku grid, it has the same "face" disposition
  #  x| 0 1 2 | 3 4 5 | 6 7 8 
  # y -----------------------
  # 0 | b c a | a a a | a a a
  # 1 | a d a | a a s | a a a
  # 2 | a a a | a a a | a a a
  # -------------------------
  # 3 | a a a | a a a | a a a
  # 4 | a a a | a a a | a a a
  # 5 | a a a | a a a | a a a
  # -------------------------
  # 6 | a a a | a a a | a a a
  # 7 | a a a | a a a | a a a
  # 8 | a a a | a a a | a a a
  #     grid is a matrix where 
  #     first array y are columns
  #     second array x are lines
  #     just to be clear some examples : coordinates b(x0,y0), c(x1,y0), d(x1,y1)
  #     so (x,y) = (5, 1) lead us to grid[1][5] => s in the grid example above
def possible(y, x, n) :
  global grid
  # check each coordinates (line, column, square) regarding the coordinates of (x,y)
  # first the line : ex. above for s and y = 1 :   # 1 | a d a | a a s | a a a we check each value of the line 1 with the value of s
  for i in range(0, 9) :
    if grid[y][i] == n :
      return False
  # then column : ex. above for s and x = 5 : 
  # 5
  # -
  # a
  # s
  # a
  # -
  # a
  # a
  # a
  # -
  # a
  # a
  # a
  for i in range(0, 9) :
    if grid[i][x] == n :
      return False
  # then we check each coordinates of the same "square"
  # ex. above for s :
  #  x| 3 4 5 
  # y --------
  # 0 | a a a 
  # 1 | a a s 
  # 2 | a a a 
  # find the head corner of the square
  x0 = (x//3) * 3 # 5 divide (floor //) by 3 = 1 * 3 = 3
  y0 = (y//3) * 3 # 1 divide (floor //) by 3 = 0 * 3 = 0
  for i in range(0,3) :
    for j in range(0,3) :
      if grid[y0 + i][x0 + j] == n :
        return False
  return True
# end of the function possible
def solve() :
  global grid
  global solution
  # we test every cell of the matrix of the sudoku grid (0, 0), (1, 0), (2, 0) ... (0, 1), (1, 1), .... (8, 8)
  for y in range(0,9) :
    for x in range(0,9) :
      if grid[y][x] == 0 : # by default an empty cell value is 0, and we are looking for those cells only
        for n in range(1, 10) : #and check for every values from 1 to 9 if it's possible
          if possible(y, x, n) :
            grid[y][x] = n # well if n is a possible value, then we insert this value to those coordinates and verify if the rest of the grid goes with it
            solve() # we call the function again and again and check all empty cell, putting possible values when we can
            grid[y][x] = 0 # don't think this is not call everytime, cause it is after every solve() where an empty cell is found.
            # solve() will eventually find a solution when we have no cell empty. Or not, and in this case, it's a dead end (see return below)
            # it's very important to reset the coordinates to 0 (empty) so we can test another value n
        return # we stop here, cause if we are here, it's because there is an empty cell, remember solution will be find by solve() recursion children 2 lines before
  solution += 1
  print( "Solution n°" + str(solution) )
  print(*grid) # if we are here, then we have a solution on recursion - no more empty cell (since we recurse on solve in "if possible", we can have more than one solution)
# end function solve()

solution = 0
grid = [
  [0,0,4,0,1,0,0,6,8],
  [0,3,0,0,9,0,0,0,0],
  [0,6,7,4,0,0,0,0,0],
  [0,0,0,9,7,0,0,1,3],
  [0,0,8,0,0,0,9,0,0],
  [5,1,0,0,2,3,0,0,0],
  [0,0,0,0,0,9,4,3,0],
  [0,0,0,0,3,0,0,9,0],
  [7,9,0,0,5,0,1,0,0]
]
print("Grille :")
print(*grid)
solve()
print("##########")

#############################
solution = 0
grid = [
  [0,0,4,0,1,0,0,6,8],
  [0,3,0,0,9,0,0,0,0],
  [0,6,7,4,0,0,0,0,0],
  [0,0,0,9,7,0,0,1,3],
  [0,0,8,0,0,0,9,0,0],
  [5,1,0,0,2,3,0,0,0],
  [0,0,0,0,0,9,4,0,0],
  [0,0,0,0,3,0,0,0,0],
  [7,9,0,0,5,0,1,0,0]
]
print("Grille :")
print(*grid)
solve()
print("##########")

#############################
solution = 0
grid = [
  [0,0,6,0,3,0,7,0,0],
  [0,3,0,5,0,8,0,9,0],
  [8,0,0,4,0,7,0,0,6],
  [0,9,0,0,0,0,0,3,0],
  [0,0,0,8,2,9,0,0,0],
  [0,6,0,0,0,0,0,2,0],
  [3,0,0,6,0,4,0,0,9],
  [0,4,0,2,0,1,0,8,0],
  [0,0,1,0,5,0,2,0,0]
]
print("Grille :")
print(*grid)
solve()
print("##########")
