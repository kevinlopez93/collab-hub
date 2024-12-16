# spec/services/boards/create_spec.rb
require 'rails_helper'

RSpec.describe Boards::Create, type: :service do
  let(:user) { create(:user) }
  let(:project) { create(:project, created_by: user) }
  let(:valid_params) { { name: "My Board", project_id: project.id } }

  describe '#call' do
    context 'when valid params are provided' do
      it 'creates a board with the correct parameters' do
        service = Boards::Create.new(valid_params, user)

        board = service.call

        # Verifica que el board se haya creado correctamente
        expect(board).to be_persisted
        expect(board.name).to eq("My Board")
        expect(board.created_by).to eq(user)
      end
    end

    context 'when invalid params are provided' do
      it 'does not create a board' do
        invalid_params = { name: nil }
        service = Boards::Create.new(invalid_params, user)

        board = service.call

        # Verifica que el board no se haya creado
        expect(board).not_to be_persisted
      end
    end
  end
end