# spec/services/users/update_spec.rb
require 'rails_helper'

RSpec.describe Users::Update, type: :service do
  let(:user) { create(:user) }
  let(:valid_params) { { username: "updated_username", email: "updated_email@example.com" } }
  let(:invalid_params) { { username: nil, email: "invalid_email" } }

  describe '#call' do
    context 'when valid params are provided' do
      it 'updates the user with the correct parameters' do
        service = Users::Update.new(user, valid_params)

        updated_user = service.call

        # Verifica que el usuario haya sido actualizado correctamente
        expect(updated_user).to be_persisted
        expect(updated_user.username).to eq("updated_username")
        expect(updated_user.email).to eq("updated_email@example.com")
      end
    end
  end
end