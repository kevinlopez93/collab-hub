module Boards
  class Update
    def initialize(board, params)
      @params = params
      @board = board
    end

    def call
      @board.update(@params)
    end
  end
end
