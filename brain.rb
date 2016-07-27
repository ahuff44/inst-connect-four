# Public
def get_move(board, me)
  good, nice, meh, semibad, bad = get_move_helper(board, me)
  choices = [good, nice, meh, semibad, bad].reject{ |moves| moves.empty? }.first
  random_choice(board, me, choices)
end

def get_move_helper(board, me)
  him = (me == 1) ? 2 : 1

  meh = valid_moves(board)

  ### 1.1 Win
  good = get_winning_moves(board, me, meh)
  if !good.empty?
    return [good, [], [], [], []]
  end

  ### 1.2 Block
  good = get_winning_moves(board, him, meh)
  if !good.empty?
    return [good, [], [], [], []]
  end

  ### 1.3 Don't play a move that lets him win
  bad, meh = meh.clone.partition do |cc|
    board_1 = simulate_move(board, cc, me)
    board_12 = simulate_move(board_1, cc, him)
    if board_12.nil?
      false # add to meh list
    else
      winner(board_12) == him
    end
  end

  ### 2.1 Create doubles
  nice, meh = meh.clone.partition do |cc|
    board_1 = simulate_move(board, cc, me)
    wins = get_winning_moves(board_1, me, valid_moves(board_1))
    wins.length >= 2 # if I was allowed to go again, are there two ways to win?
  end
  if !nice.empty?
    return [[], nice, [], [], []]
  end

  ### 2.2 Avoid allowing blocking
  semibad, meh = meh.clone.partition do |cc|
    board_2 = simulate_move(board, cc, him)
    board_21 = simulate_move(board_2, cc, me)
    if board_21.nil?
      false # simulation failed
    else
      winner(board_21) == me
      # leave in the tension - he can't go there (b/c when I play on top of him there I get 4-in-a-row)
    end
  end

  return [[], [], meh, semibad, bad]
end

def get_winning_moves(board, me, candidates)
  # returns a list of moves that win.
  # this is a helper method for get_move
  candidates.select { |cc| winner(simulate_move(board, cc, me)) == me }
end

def random_choice(board, me, choices)
  him = (me == 1) ? 2 : 1

  choices.shuffle!

  ### 1.1 Block 3-in-a-row...
  current_counts = contiguous_counts(board) # speed: cache this. maybe unecessary?
  choices.each do |cc|
    if contiguous_counts(simulate_move(board, cc, him))[him][3] > current_counts[him][3]
      return cc
    end
  end

  ### 1.2 ... and create 3-in-a-row
  choices.each do |cc|
    if contiguous_counts(simulate_move(board, cc, me))[me][3] > current_counts[me][3]
      return cc
    end
  end

  ### 2.1 else, choose from least full columns...
  groups = choices.group_by do |cc|
    col = (board.transpose)[cc]
    col.count(0)
  end

  choices = groups[groups.keys.max]

  ### 2.2 ...and play randomly
  return choices.sample
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
  else
    if index.nil? # column empty
      index = col.length - 1
    else
      index = index - 1
    end

    new_board[index][cc] = player
    new_board
  end
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
