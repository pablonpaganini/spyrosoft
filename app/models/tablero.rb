class Tablero < ApplicationRecord
  SIZE = 3
  
  # Inicializa un nuevo tablero
  def inicializar
    # 0 dead - 1: alive
    self.state = [[0,1,1],[1,0,0],[0,0,1]].to_json
  end

  # Evalúa el tablero con las reglas del Juego de la Vida
  def aplicar_reglas
    tablero = JSON.parse(self.state)
    nuevo_tablero = Marshal.load(Marshal.dump(tablero)) # Deep copy

    SIZE.times do |i|
      SIZE.times do |j|
        puts "position (#{i},#{j}) = #{nuevo_tablero[i][j]}"
        vecinos = piezas_vecinas(i, j, tablero)
        p vecinos
        piezas_vecinas_vivas = vecinos.select{ |num|  num.positive?  }.count 
        p "vecinas vivas: #{piezas_vecinas_vivas}"
        
        if tablero[i][j] == 1
          # Any live cell with fewer than two live neighbours dies, as if by underpopulation.
          # Any live cell with more than three live neighbours dies, as if by overpopulation.
          # Any live cell with two or three live neighbours lives on to the next generation.
          p "Any live cell with two or three live neighbours survives."          
          if piezas_vecinas_vivas < 2 || piezas_vecinas_vivas > 3 
            nuevo_tablero[i][j] = 0
          end
        else
          # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
          p "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction."
          if piezas_vecinas_vivas == 3
            nuevo_tablero[i][j] = 1
          end
        end
      end
    end
    self.game_end = juego_completado?(nuevo_tablero)
    self.state = nuevo_tablero.to_json
  end

  private
  
  # Devuelve las piezas vecinas para una casilla dada
  def piezas_vecinas(x, y, tablero)
    [
      [x-1, y-1], [x, y-1], [x+1, y-1],
      [x-1, y],             [x+1, y],
      [x-1, y+1], [x, y+1], [x+1, y+1]
    ].select { |i, j| i.between?(0, SIZE-1) && j.between?(0, SIZE-1) }
     .map { |i, j| tablero[i][j] }
     .compact
  end

  def juego_completado?(nuevo_tablero)
    # Chequeo horizontal
    SIZE.times do |j|
      q = nuevo_tablero[j].sum
      p "Chequeo horizontal en #{j} da como suma #{q}"
      return true if q == 3 || q == 0
    end
    # Chequeo vertical
    SIZE.times do |j|
      q = nuevo_tablero[0][j] + nuevo_tablero[1][j] + nuevo_tablero[2][j]
      p "Chequeo vertical en #{j} da como suma #{q}"
      return true if q == 3 || q == 0
    end
    # Chequeo diagonal
    q = nuevo_tablero[0][0] + nuevo_tablero[1][1] + nuevo_tablero[2][2]
    p "Chequeo diagonal en (0-4-8) da como suma #{q}"
    return true if q == 3 || q == 0
    q = nuevo_tablero[0][2] + nuevo_tablero[1][1] + nuevo_tablero[2][0]
    p "Chequeo diagonal en (2-4-6) da como suma #{q}"
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
