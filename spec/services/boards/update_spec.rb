# spec/services/boards/update_spec.rb
require 'rails_helper'

RSpec.describe Boards::Update, type: :service do
  let(:board) { create(:board) }
  let(:valid_params) { { name: "Updated Board Name" } }
  let(:invalid_params) { { name: nil, project_id: nil } }

  describe '#call' do
    context 'when valid params are provided' do
      it 'updates the board with the correct parameters' do
        service = Boards::Update.new(board, valid_params)

        updated_board = service.call

        # Verifica que el board haya sido actualizado correctamente
        expect(updated_board).to be_truthy
        expect(board.reload.name).to eq("Updated Board Name")
      end
    end

    context 'when invalid params are provided' do
      it 'does not update the board' do
        service = Boards::Update.new(board, invalid_params)

        updated_board = service.call

        # Verifica que el board no haya sido actualizado
        expect(updated_board).to be_falsey
        expect(board.reload.name).not_to eq(nil)
      end
    end
  end
end
