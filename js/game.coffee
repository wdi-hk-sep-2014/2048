WinningTileValue = 2048

# covered
@ppArray = (a) ->
  for row in a
    console.log row

# covered
@buildBoard = ->
  [0..3].map -> [0..3].map -> 0

# covered
@getRow = (rowNumber, board) ->
  [r, b] = [rowNumber, board]
  [b[r][0], b[r][1], b[r][2], b[r][3]]

# covered
@getColumn = (columnNumber, board) ->
  column = []
  for row in [0..3]
    column[row] = board[row][columnNumber]
  column

# covered
@setRow = (row, rowNumber, board) ->
  board[rowNumber] = row

# covered
@setColumn = (column, columnNumber, board) ->
  for i in [0..3]
    board[i][columnNumber] = column[i]
  getColumn(columnNumber, board)

# covered
@arrayEqual = (a, b) ->
  for val, i in a
    if val != b[i]
      return false
  true

# covered
@boardEqual = (a, b) ->
  for row, i in a
    unless arrayEqual(row, b[i])
      return false
  true

# covered
@moveIsValid = (a, b) ->
  not boardEqual(a,b)

@noValidMoves = (board) ->
  directions = ['up', 'down', 'left', 'right']

  for direction in directions
    newBoard = move(board, direction)
    return false if moveIsValid(newBoard, board)
  true

# covered
@getTileValue = ->
  values = [2, 2, 2, 4]
  val = values[Math.floor(Math.random() * values.length)]

# covered
# returns random integer from 0 to x-1
@randomInt = (x) ->
  Math.floor(Math.random() * x)

# covered
@randomCellIndices = ->
  [randomInt(4), randomInt(4)]

# covered
@boardIsFull = (board) ->
  for row in board
    if $.inArray(0, row) > -1
      return false
  true

# covered
@generateTile = (board) ->
  value = getTileValue()
  [row, column] = randomCellIndices()

  if board[row][column] == 0
    board[row][column] = value
  else
    unless boardIsFull(board)
      generateTile(board)

# covered
@move = (board, direction) ->

  newBoard = buildBoard()

  for i in [0..3]
    switch direction
      when 'right', 'left'
        row = mergeCells(getRow(i, board), direction)
        row = collapseCells(row, direction)
        setRow(row, i, newBoard)
      when 'up', 'down'
        column = mergeCells(getColumn(i, board), direction)
        column = collapseCells(column, direction)
        setColumn(column, i, newBoard)
  newBoard

# covered
@mergeCells = (cells, direction) ->

  merge = (cells) ->
    for i in [3...0]
      for j in [i-1..0]
        [n, m] = [cells[i], cells[j]]

        if n == 0 then break
        else if n == m
          cells[i] *= 2
          cells[j] = 0
          break
        else if m != 0 then break

    cells

  switch direction
    when 'right', 'down'
      cells = merge cells
    when 'left', 'up'
      cells = merge(cells.reverse()).reverse()
  cells

# covered
@collapseCells = (cells, direction) ->

  cells = cells.filter (x) -> x != 0
  padding = 4 - cells.length

  for i in [0...padding]
    switch direction
      when 'right', 'down' then cells.unshift 0
      when 'left', 'up' then cells.push 0
  cells

@gameWon = (board) ->
  for row in board
    for cell in row
      if cell >= WinningTileValue
        return true
  false

@gameLost = (board) ->
  boardIsFull(board) && noValidMoves(board)

# covered
@showValue = (value) ->
  if value == 0 then "" else value

# covered
@showBoard = (board) ->
  for r in [0..3]
    for c in [0..3]
      $(".r#{r}.c#{c} > div").html(showValue(board[r][c]))

