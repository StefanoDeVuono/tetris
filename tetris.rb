require 'debugger'

class Game

  attr_reader :board

  def initialize
    @board = Array.new(20) {Array.new(10) {:_}}
  end

  def add_piece(piece)
    piece.upper_left = [0,0]
  end

  def display
    @board.each do |row|
      row.each {|spot| print "#{spot} "}
      puts
    end
  end
  

  def place_piece(piece)
    # add upperleft to each delta
    position = piece.deltas.map do |delta|
      add_arrays([piece.upper_left, delta])
    end 
    position.each do |spot|
      @board[spot.first][spot.last] = :x
    end
  end

  def erase_previous_positions(piece)
    prev_upper_left = piece.upper_left.first - 1, piece.upper_left.last
    piece.deltas.each do |delta|
      if delta.first == 0
        old_position = add_arrays([prev_upper_left, delta])
        @board[old_position.first][old_position.last] = :_
      end
    end
  end

  def free_movement(piece)
    test_postions = piece.deltas.map do |spot|
      add_arrays([spot, [1, 0]])
    end
    test_postions.none? do |position|
      @board[position.first][position.last] == :x
    end
  end

  def drop_piece(piece)
    while piece.lower_right.first < @board.length - 1 and free_movement(piece)
      piece.upper_left = piece.upper_left.first + 1, piece.upper_left.last
      erase_previous_positions(piece)
    end
    place_piece(piece)
  end

  def add_arrays(arr)
    # takes a big meta-array, adds the contents of the sub-arrays
    arr.transpose.map do |x|
      x.reduce(:+)
    end
  end

end



class Piece

  attr_accessor :upper_left
  attr_reader :deltas

  def initialize(upper_left, deltas)
    @upper_left = upper_left
    @deltas = deltas
  end

  def lower_right
    row = @deltas.map {|arr| arr.first}
    col = @deltas.map {|arr| arr.last}
    add_arrays( [upper_left, [row.max, col.max]])
  end

  def add_arrays(arr)
    # takes a big meta-array, adds the contents of the sub-arrays
    arr.transpose.map do |x|
      x.reduce(:+)
    end
  end

end 

square_deltas = [[0,0],
                 [0,1],
                 [1,0],
                 [1,1]]

g = Game.new
s = Piece.new([0,0], square_deltas)
puts 'board at beginning'
g.display
g.add_piece(s)
g.drop_piece(s)
puts
puts 'board after placing piece'
g.display


#square = [[:x, :x][:x, :x]]
# upper_left = [0,col]





# upper_left = [1, col]

#clear board as piece moves

# def lower_right
#   #calculate lower right bound of piece
#   # [row, col]
# end