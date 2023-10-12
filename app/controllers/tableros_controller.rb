class TablerosController < ApplicationController
  def show
    @tablero = Tablero.last || Tablero.create
    unless @tablero.state
      @tablero.start 
      @tablero.save
    end
  end

  def update
    @tablero = Tablero.last
    @tablero.apply_rules
    @tablero.save
    redirect_to tablero_url(@tablero)
  end

  def reset
    @tablero = Tablero.create
    redirect_to tablero_url(@tablero)
  end
end
