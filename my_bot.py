import json

while True:
  game_state = json.loads(gets)
  row_height = game_state["board"].length
  column_width = game_state["board"][0].length

  if game_state["winner"]
    break
  end

  puts rand(column_width)
end

