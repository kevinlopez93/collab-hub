require "rails_helper"

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:board) { create(:board, created_by: user) }
  let!(:task) { create(:task, board: board, creator: user) }
  let(:task_params) { { title: "New Task", description: "Task description", board_id: board.id, due_date: Time.zone.today } }
  let(:invalid_task_params) { { title: "", description: "", board_id: nil } }
  let(:users_assigned) { [create(:user).id] }

  describe "GET #index" do
    let!(:tasks) { create_list(:task, 2, board: board, creator: user) }

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
      get :index, params: { q: { title_cont: task.title } }
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end

    it "returns http success with empty result" do
      login user
      get :index, params: { q: { title_cont: "invalid" } }
      expect(response).to have_http_status(:success)
      expect(json).to eq([])
    end
  end

  describe "GET #show" do
    it "returns http unauthorized" do
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
      expect(json["task"]["title"]).to eq(task.title)
    end

    it "returns http not found for invalid id" do
      login user
      get :show, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "returns http unauthorized" do
      post :create, params: { task: task_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid params" do
      login user
      post :create, params: { task: task_params, users_assigned: users_assigned }
      expect(response).to have_http_status(:ok)
      expect(json["task"]["title"]).to eq("New Task")
      expect(json["task"]["users_assigned"].length).to eq(1)
    end

    it "returns http unprocessable entity with invalid params" do
      login user
      post :create, params: { task: invalid_task_params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT #update" do
    let(:update_params) { { title: "Updated Task", description: "Updated description" } }

    it "returns http unauthorized" do
      put :update, params: { id: task.id, task: update_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid params" do
      login user
      put :update, params: { id: task.id, task: update_params, users_assigned: users_assigned }
      expect(response).to have_http_status(:ok)
      expect(task.reload.title).to eq("Updated Task")
    end
  end

  describe "PUT #update_states" do
    let(:event_params) { { event: "to_start" } }

    it "returns http unauthorized" do
      put :update_states, params: { id: task.id, task: event_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid event" do
      login user
      put :update_states, params: { id: task.id, task: event_params }
      expect(response).to have_http_status(:ok)
    end

    it "returns http unprocessable entity with invalid event" do
      login user
      put :update_states, params: { id: task.id, task: { event: "invalid_event" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Invalid event")
    end
  end

  describe "DELETE #destroy" do
    it "returns http unauthorized" do
      delete :destroy, params: { id: task.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      delete :destroy, params: { id: task.id }
      expect(response).to have_http_status(:ok)
      expect(Task.find_by(id: task.id)).to be_nil
    end
  end
end