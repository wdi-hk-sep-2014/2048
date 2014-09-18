$ ->

  # ===============
  # keyboard events
  # ===============

  $('body').keydown (e) =>
    key = e.which
    keys = [37..40] # arrow key codes

    # prevent default key behavior for arrow keys only
    if $.inArray(key, keys) > -1
      e.preventDefault()

    direction = switch key
      when 37 then 'left'
      when 38 then 'up'
      when 39 then 'right'
      when 40 then 'down'

    newBoard = move(@board, direction)

    if moveIsValid(newBoard, @board)
      @board = newBoard
      generateTile(@board)
      showBoard(@board)
      if gameLost(@board)
        console.log "Game Over!"
      else if gameWon(@board)
        console.log "Congrats!"

  # ==========
  # init stuff
  # ==========

  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  showBoard(@board)
