class Tablero < ApplicationRecord
  SIZE = 3
  
  # Start new board
  def start
    # 0 dead - 1: alive
    self.state = [[0,1,1],[1,0,0],[0,0,1]].to_json
  end

  # Apply game of live rules
  def apply_rules
    board = JSON.parse(self.state)
    new_board = Marshal.load(Marshal.dump(board)) # Deep copy

    SIZE.times do |i|
      SIZE.times do |j|
        puts "position (#{i},#{j}) = #{new_board[i][j]}"
        vecinos = neighbor_pieces(i, j, board)
        p vecinos
        neighbor_pieces_vivas = vecinos.select{ |num|  num.positive?  }.count 
        p "vecinas vivas: #{neighbor_pieces_vivas}"
        
        if board[i][j] == 1
          # Any live cell with fewer than two live neighbours dies, as if by underpopulation.
          # Any live cell with more than three live neighbours dies, as if by overpopulation.
          # Any live cell with two or three live neighbours lives on to the next generation.
          p "Any live cell with two or three live neighbours survives."          
          if neighbor_pieces_vivas < 2 || neighbor_pieces_vivas > 3 
            new_board[i][j] = 0
          end
        else
          # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
          p "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction."
          if neighbor_pieces_vivas == 3
            new_board[i][j] = 1
          end
        end
      end
    end
    self.game_end = game_complete?(new_board)
    self.state = new_board.to_json
  end

  private
  
  # Get neighbor pieces for an specific cell
  def neighbor_pieces(x, y, board)
    [
      [x-1, y-1], [x, y-1], [x+1, y-1],
      [x-1, y],             [x+1, y],
      [x-1, y+1], [x, y+1], [x+1, y+1]
    ].select { |i, j| i.between?(0, SIZE-1) && j.between?(0, SIZE-1) }
     .map { |i, j| board[i][j] }
     .compact
  end

  def game_complete?(new_board)
    # Check horizontal
    SIZE.times do |j|
      q = new_board[j].sum
      p "Check horizontal for #{j} get as sum #{q}"
      return true if q == 3 || q == 0
    end
    # Check vertical
    SIZE.times do |j|
      q = new_board[0][j] + new_board[1][j] + new_board[2][j]
      p "Check vertical en #{j} get as sum #{q}"
      return true if q == 3 || q == 0
    end
    # Check diagonal
    q = new_board[0][0] + new_board[1][1] + new_board[2][2]
    p "Check diagonal en (0-4-8) get as sum #{q}"
    return true if q == 3 || q == 0
    q = new_board[0][2] + new_board[1][1] + new_board[2][0]
    p "Check diagonal en (2-4-6) get as sum #{q}"
    return true if q == 3 || q == 0
    false
  end
end

=begin

Gen 0  Gen 1
O	X	X  O X O
X	O	O  O O X
O	O	X  O O O

=end
