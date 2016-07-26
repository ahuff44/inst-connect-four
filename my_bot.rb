require "json"
require File.join(File.dirname(__FILE__), 'brain.rb')

$stdin.sync = true
$stdout.sync = true

def main
  loop do
    game_state = JSON.parse(gets)
    board = game_state["board"]

    if game_state["winner"]
      break
    end

    puts get_move(board)
  end
end









$arr = [[1,2,3], [4,5,6]]
$b1 = [
    ["0", "0", "0", "0", ],
    ["1", "0", "0", "2", ],
    ["2", "0", "1", "1", ],
    ["1", "1", "2", "2", ],
]

def get_move(board)
  height = board.length
  width = board[0].length
  choices = valid_moves(board)
  puts choices
  choices.sample
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

def slices(board, length=4, &block)
  dirs = [
    [0, 1], # right
    [1, 1], # down-right
    [1, 0], # down
    [1, -1], # down-left
  ]
  board.each_with_index do |row, rr|
    row.each_with_index do |entry, cc|
      dirs.each do |dr, dc|
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
          yield slice
        end
      end
    end
  end
end








main