require "json"
require File.join(File.dirname(__FILE__), 'brain.rb')

$stdin.sync = true
$stdout.sync = true

loop do
  game_state = JSON.parse(gets)
  board = game_state["board"]

  if game_state["winner"]
    break
  end

  puts get_move(board)
end
