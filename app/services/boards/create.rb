module Boards
  class Create
    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    def call
      Board.create(@params.merge!(created_by: @current_user))
    end
  end
end