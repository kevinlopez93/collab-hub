# spec/services/users/create_spec.rb
require 'rails_helper'

RSpec.describe Users::Create, type: :service do
  let(:valid_params) do
    {
      username: "john_doe",
      email: "john_doe@example.com",
      password: "password123"
    }
  end

  let(:invalid_params) do
    {
      username: nil,
      email: "invalid_email",
      password: "password123"
    }
  end

  describe '#call' do
    context 'when valid params are provided' do
      it 'creates a user with the correct parameters' do
        service = Users::Create.new(valid_params)

        user = service.call

        # Verifica que el usuario haya sido creado correctamente
        expect(user).to be_persisted
        expect(user.username).to eq("john_doe")
        expect(user.email).to eq("john_doe@example.com")
      end
    end

    context 'when invalid params are provided' do
      it 'does not create a user' do
        service = Users::Create.new(invalid_params)

        user = service.call

        # Verifica que el usuario no se haya creado
        expect(user).not_to be_persisted
        expect(user.errors[:username]).to include("can't be blank")
      end
    end
  end
end
