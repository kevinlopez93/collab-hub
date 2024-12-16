require "rails_helper"

RSpec.describe Api::V1::BoardsController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:project) { create(:project, created_by: user) }
  let!(:board) { create(:board, project: project, created_by: user) }
  let(:board_params) { { name: "New Board", project_id: project.id } }
  let(:invalid_board_params) { { name: "", project_id: nil } }

  describe "GET #index" do
    let!(:boards) { create_list(:board, 2, project: project, created_by: user) }

    it "returns http unauthorized" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :index
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(3)
    end

    it "returns http success with filter params" do
      login user
      get :index, params: { q: { name_cont: board.name } }
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end
  end

  describe "GET #show" do
    it "returns http unauthorized" do
      get :show, params: { id: board.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :show, params: { id: board.id }
      expect(response).to have_http_status(:ok)
      expect(json["board"]["name"]).to eq(board.name)
    end

    it "returns http not found for invalid id" do
      login user
      get :show, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "returns http unauthorized" do
      post :create, params: { board: board_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid params" do
      login user
      post :create, params: { board: board_params }
      expect(response).to have_http_status(:ok)
      expect(json["board"]["name"]).to eq("New Board")
    end

    it "returns http unprocessable entity with invalid params" do
      login user
      post :create, params: { board: invalid_board_params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT #update" do
    let(:update_params) { { name: "Updated Board" } }

    it "returns http unauthorized" do
      put :update, params: { id: board.id, board: update_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid params" do
      login user
      put :update, params: { id: board.id, board: update_params }
      expect(response).to have_http_status(:ok)
      expect(board.reload.name).to eq("Updated Board")
    end

    it "returns http unprocessable entity with invalid params" do
      login user
      put :update, params: { id: board.id, board: invalid_board_params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it "returns http unauthorized" do
      delete :destroy, params: { id: board.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      delete :destroy, params: { id: board.id }
      expect(response).to have_http_status(:ok)
      expect(Board.find_by(id: board.id)).to be_nil
    end
  end
end
