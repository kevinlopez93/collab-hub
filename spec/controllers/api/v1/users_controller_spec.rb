require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:new_user) { create(:user, :admin, username: "new_user") }
  let(:params) { { q: { username_cont: new_user.username } } }
  let(:params_user) { { username: "username", email: "email@test.com", password: "password" } }

  describe "GET #index" do
    it "returns http unauthorized" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns http success with filter params" do
      login user
      get :index, params: params
      expect(response).to have_http_status(:success)
      expect(json[0]["username"]).to eq(new_user.username)
    end

    it "returns http success with empty result" do
      login user
      get :index, params: { q: { username_cont: "invalid" } }
      expect(response).to have_http_status(:success)
      expect(json).to eq([])
    end
  end

  describe "GET #show" do
    it "returns http unauthorized" do
      get :show, params: { username: user.username }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :show, params: { username: user.username }
      expect(response).to have_http_status(:success)
    end

    it "returns http not found" do
      login user
      get :show, params: { username: "invalid" }
      expect(response).to have_http_status(:not_found)
    end

    it "returns http success with valid username" do
      login user
      get :show, params: { username: user.username }
      expect(json["user"]).to eq(UserSerializer.new(user).as_json.stringify_keys)
    end
  end

  describe "POST #create" do
    it "returns http success without login" do
      login user
      post :create, params: { user: params_user }
      expect(response).to have_http_status(:success)
      expect(json["user"].keys).to eq(UserSerializer.new(new_user).as_json.stringify_keys.keys)
    end

    it "returns http success with invalid params" do
      login user
      post :create, params: { user: { username: "", email: "", password: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT #update" do
    it "returns http unauthorized" do
      put :update, params: { username: new_user.username, user: { role: RoleUserEnum::DEVELOPER } }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      put :update, params: { username: new_user.username, user: { role: RoleUserEnum::DEVELOPER } }

      expect(response).to have_http_status(:success)
      expect(new_user.reload.role).to eq(RoleUserEnum::DEVELOPER)
      expect(json["user"]).to eq(UserSerializer.new(new_user).as_json.stringify_keys)
    end
  end
end
