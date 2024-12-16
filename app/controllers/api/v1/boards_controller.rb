class Api::V1::BoardsController < ApplicationController
  before_action :set_board, only: %i[show update destroy]

  def index
    boards = policy_scope(Board).ransack(params[:q]).result
    @pagy, records = pagy(boards)
    render json: records, each_serializer: BoardSerializer, status: :ok
  end

  def show
    authorize @board
    render json: { board: BoardSerializer.new(@board) }, status: :ok
  end

  def create
    board = Boards::Create.new(board_params, current_user).call

    if board.persisted?
      render json: { board: BoardSerializer.new(board) }, status: :ok
    else
      render json: { errors: board.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @board

    service = Boards::Update.new(@board, board_params)
    if service.call
      render json: { board: BoardSerializer.new(@board) }, status: :ok
    else
      render json: { errors: @board.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @board
    @board.destroy!
    render json: { board: BoardSerializer.new(@board) }, status: :ok
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:name, :project_id)
  end
end
