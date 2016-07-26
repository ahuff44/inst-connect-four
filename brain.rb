$arr = [[1,2,3], [4,5,6]]
$b0 = [[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]]
$b1 = [
    [0, 0, 0, 0, 0, 2],
    [1, 0, 0, 2, 0, 1],
    [2, 0, 1, 1, 0, 1],
    [1, 1, 2, 2, 0, 1],
]
$b2 = [
    [0, 0, 0, 0],
    [1, 0, 2, 0],
    [1, 0, 2, 0],
    [1, 0, 2, 0],
]
$b3 = [
    [1, 0, 0, 0],
    [1, 0, 2, 0],
    [1, 0, 2, 0],
    [1, 0, 2, 0],
]
$b4 = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ],
  [0, 1, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, ],
  [0, 2, 1, 1, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, ],
]
$b5 = [
  [0, 0, 0, 0, 0, ],
  [0, 0, 0, 0, 0, ],
  [0, 0, 0, 0, 0, ],
  [0, 0, 0, 0, 0, ],
  [2, 2, 0, 2, 2, ],
  [2, 1, 0, 1, 2, ],
]
$b6 = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, ],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, ],
  [2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 1, ],
  [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 2, ],
  [1, 1, 1, 2, 0, 1, 2, 1, 1, 1, 2, 2, ],
  [1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, ],
]

def get_move(board, me)
  him = (me == 1) ? 2 : 1

  height = board.length
  width = board[0].length
  choices = valid_moves(board)

  ### 1. Win or block
  choices.each do |cc|
    board_1 = simulate_move(board, cc, me)
    board_2 = simulate_move(board, cc, him)
    if winner(board_1) == me or winner(board_2) == him
      return cc
    end
  end
  ### 2. Don't play a move that lets him win
  choices.reject! do |cc|
    board_1 = simulate_move(board, cc, me)
    board_12 = simulate_move(board_1, cc, him)
    if board_12.nil?
      false # don't delete this choice
    end
    winner(board_12) == him
  end

  # else, rando
  choices.sample
end

def winner(board)
  # returns winner. 0 is special.
  slices(board) do |slice|
    if slice.uniq.length == 1
      if slice.uniq[0] != 0 # special
        return slice.uniq[0]
      end
    end
  end
  return 0
end

def clone_board(board)
  board.each_with_object([]) do |row, new_board|
    new_board << row.clone
  end
end

def simulate_move(board, cc, player)
  # assert cc in valid_moves(board)

  new_board = clone_board(board)
  col = (new_board.transpose)[cc]
  index = col.find_index { |e| e != 0 }
  if index == 0
    nil
  elsif index.nil? # column empty
    index = col.length - 1
  else
    index = index - 1
  end

  new_board[index][cc] = player
  new_board
end

def valid_moves(board)
  good = []
  board[0].each_with_index do |top_entry, cc|
    if top_entry == 0
      good << cc
    end
  end
  good
end

def board_get(board, rr, cc)
  if rr < 0 or cc < 0
    return nil
  end

  if board[rr].nil?
    return nil
  else
    return board[rr][cc]
  end
end

def slices(board, &block)
  _length = 4
  _dirs = [
    [0, 1], # right
    [1, 1], # down-right
    [1, 0], # down
    [1, -1], # down-left
  ]
  board.each_with_index do |row, rr|
    row.each_with_index do |entry, cc|
      _dirs.each do |dr, dc|
        slice = []
        valid = true
        (0.._length-1).each do |ii|
          entry = board_get(board, rr+ii*dr, cc+ii*dc)
          if entry.nil?
            valid = false
          end
          slice << entry
        end
        if valid
          yield slice
        end
      end
    end
  end
end
