require File.expand_path(File.dirname(__FILE__) + '/../brain.rb')
require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe "brain" do

  it "passes legacy tests" do
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
    # $b3 = [
    #     [1, 0, 0, 0],
    #     [1, 0, 2, 0],
    #     [1, 0, 2, 0],
    #     [1, 0, 2, 0],
    # ]
    $b4 = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0],
      [0, 2, 1, 1, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    ]
    $b5 = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [2, 2, 0, 2, 1],
      [2, 1, 0, 1, 2],
    ]
    $b6 = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2],
      [2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 1],
      [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 2],
      [1, 1, 1, 2, 0, 1, 2, 1, 1, 1, 2, 2],
      [1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2],
    ]

    def ahuff_assert(tag, a, b)
      if a != b
        raise tag
      end
    end

    puts "Running tests"
    ahuff_assert("$b0 1", [0,1,2,3,4,5].include?(get_move($b0, 1)), true)
    ahuff_assert("$b0 1", [0,1,2,3,4,5].include?(get_move($b0, 2)), true)

    ahuff_assert("$b1 1", get_move($b1, 1), 4)
    ahuff_assert("$b1 2", get_move($b1, 2), 1)

    ahuff_assert("$b2 1", get_move($b2, 1), 0)
    ahuff_assert("$b2 2", get_move($b2, 2), 2)

    ahuff_assert("$b4 1", get_move($b4, 1), 3)
    ahuff_assert("$b4 2", get_move($b4, 2), 3)

    ahuff_assert("$b5 1", get_move($b5, 1), 0)
    ahuff_assert("$b5 2", get_move($b5, 2), 2)

    # ahuff_assert("$b6 1", get_move($b6, 1), 4)
    # ahuff_assert("$b6 2", get_move($b6, 2), 4)
  end

  describe "basic logic" do
    it "wins" do
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 1, 0],
      ]
      expect(get_move(board, 1)).to be 3
      board = [
        [0, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
      ]
      expect(get_move(board, 1)).to be 0
      board = [
        [0, 0, 0, 0],
        [0, 0, 1, 2],
        [0, 1, 2, 1],
        [1, 2, 2, 2],
      ]
      expect(get_move(board, 1)).to be 3
    end

    it "wins before blocking" do
      board = [
        [0, 0, 0, 0],
        [1, 0, 2, 0],
        [1, 0, 2, 0],
        [1, 0, 2, 0],
      ]
      expect(get_move(board, 1)).to be 0
      expect(get_move(board, 2)).to be 2
    end

    it "blocks" do
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 1, 0],
      ]
      expect(get_move(board, 2)).to be 3
      board = [
        [0, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
      ]
      expect(get_move(board, 2)).to be 0
      board = [
        [0, 0, 0, 0],
        [0, 0, 1, 2],
        [0, 1, 2, 1],
        [1, 2, 2, 2],
      ]
      expect(get_move(board, 2)).to be 3
    end

    it "doesn't create an easy win for the opponent" do
      board = [
        [0, 0, 2, 0],
        [0, 2, 1, 0],
        [2, 1, 1, 2],
        [1, 1, 2, 2],
      ]
      expect(get_move(board, 2)).to_not be 3
    end

    it "blocks 3-in-a-row" do
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0],
      ]
      expect(get_move(board, 2)).to be 1
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 0, 0],
      ]
      expect(get_move(board, 2)).to be 2
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 1, 2, 0],
        [1, 2, 1, 0],
      ]
      expect(get_move(board, 2)).to be 2
    end

    it "creates 3-in-a-row" do
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0],
      ]
      expect(get_move(board, 1)).to be 1
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 0, 0],
      ]
      expect(get_move(board, 1)).to be 2
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 1, 2, 0],
        [1, 2, 1, 0],
      ]
      expect(get_move(board, 1)).to be 2
    end

    it "blocks 3 before creating 3" do
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [2, 1, 0, 0],
        [2, 1, 0, 0],
      ]
      expect(get_move(board, 1)).to be 0
      expect(get_move(board, 2)).to be 1
    end

    it "plays in lowest position" do
      board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [2, 0, 1, 2],
      ]
      expect(get_move(board, 1)).to be 1
      expect(get_move(board, 2)).to be 1
    end
  end

  it "jamesw example" do
    board = [
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 0],
      [0, 0, 0, 1, 0, 2, 0],
      [0, 0, 0, 2, 2, 2, 1],
      [0, 2, 0, 2, 1, 1, 1],
    ]
    expect(get_move(board, 1)).to be 0 # 2 would block a 3-in-a-row but would let him win, so choose 0 since it's lowest
  end
end