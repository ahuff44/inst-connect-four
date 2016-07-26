load "brain.rb"; slices($arr) do |s| p s end

load "brain.rb"; slices($b1) do |s| p s end

load "brain.rb"; (0...$b1[0].length).each do |ix| p [ix, simulate_move($b1, ix, 9)] end






echo

