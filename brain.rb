def get_move(board, me)
  him = (me == 1) ? 2 : 1

  height = board.length
  width = board[0].length
  choices = valid_moves(board)

  ### 1. Win
  choices.each do |cc|
    if winner(simulate_move(board, cc, me)) == me
      return cc
    end
  end

  ### 2. Block
  choices.each do |cc|
    if winner(simulate_move(board, cc, him)) == him
      return cc
    end
  end

  ### 3. Don't play a move that lets him win
  choices.select! do |cc|
    board_1 = simulate_move(board, cc, me)
    board_12 = simulate_move(board_1, cc, him)
    if board_12.nil?
      next # simulation failed
    end
    winner(board_12) != him
  end

  ### 4. Block 3-in-a-row...
  choices.each do |cc|
    if contiguous_counts(simulate_move(board, cc, him))[him][3] > contiguous_counts(board)[him][3]
      return cc
    end
  end

  ### 5. ... and create 3-in-a-row
  choices.each do |cc|
    if contiguous_counts(simulate_move(board, cc, me))[me][3] > contiguous_counts(board)[me][3]
      return cc
    end
  end

  ### 5. else, choose from least full columns...
  groups = choices.group_by do |cc|
    col = (board.transpose)[cc]
    col.count(0)
  end

  choices = groups[groups.keys.max]

  ### 6. ...and play randomly
  choices.sample
end

def winner(board)
  # returns winner. 0 is special.
  counts = contiguous_counts(board)
  if counts[1][4] > 0
    return 1
  elsif counts[2][4] > 0
    return 2
  else
    return 0
  end
end

def contiguous_counts(board)
  # returns winner. 0 is special.
  # hack: only checks for length 3 and 4
  ["buffer"] + [1, 2].map do |pl|
    [
      "buffer",
      "buffer",
      "buffer",
      slices(board, length=3)
        .select { |s| s[0] == pl }
        .select { |s| s.uniq.length == 1 }
        .count,
       slices(board, length=4)
        .select { |s| s[0] == pl }
        .select { |s| s.uniq.length == 1 }
        .count
    ]
  end
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

def slices(board, length, &block)
  _dirs = [
    [0, 1], # right
    [1, 1], # down-right
    [1, 0], # down
    [1, -1], # down-left
  ]
  all_slices = []
  board.each_with_index do |row, rr|
    row.each_with_index do |entry, cc|
      _dirs.each do |dr, dc|
        slice = []
        valid = true
        (0..length-1).each do |ii|
          entry = board_get(board, rr+ii*dr, cc+ii*dc)
          if entry.nil?
            valid = false
          end
          slice << entry
        end
        if valid
          all_slices << slice
        end
      end
    end
  end
  all_slices
end
