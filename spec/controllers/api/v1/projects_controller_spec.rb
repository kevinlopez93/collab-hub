require "rails_helper"

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:project) { create(:project, created_by: user) }
  let(:project_params) { { name: "New Project", description: "This is a new project." } }

  describe "GET #index" do
    let!(:projects) { create_list(:project, 2, created_by: user) }

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
      get :index, params: { q: { name_cont: project.name } }
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end
  end

  describe "GET #show" do
    it "returns http unauthorized" do
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:ok)
      expect(json["project"]["name"]).to eq(project.name)
    end

    it "returns http not found for invalid id" do
      login user
      get :show, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "returns http unauthorized" do
      post :create, params: { project: project_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid params" do
      login user
      post :create, params: { project: project_params }
      expect(response).to have_http_status(:ok)
      expect(json["project"]["name"]).to eq("New Project")
    end
  end

  describe "PUT #update" do
    let(:update_params) { { name: "Updated Project" } }

    it "returns http unauthorized" do
      put :update, params: { id: project.id, project: update_params }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid params" do
      login user
      put :update, params: { id: project.id, project: update_params }
      expect(response).to have_http_status(:ok)
      expect(project.reload.name).to eq("Updated Project")
    end
  end

  describe "DELETE #destroy" do
    let(:developer_user) { create(:user, :developer) }

    it "returns http unauthorized" do
      delete :destroy, params: { id: project.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http unauthorized with not admin user" do
      login developer_user
      delete :destroy, params: { id: project.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      delete :destroy, params: { id: project.id }
      expect(response).to have_http_status(:ok)
      expect(Project.find_by(id: project.id)).to be_nil
    end
  end

  describe "GET #statistics" do
    it "returns http unauthorized" do
      get :statistics, params: { id: project.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :statistics, params: { id: project.id }
      expect(response).to have_http_status(:ok)
      expect(json.keys).to include("tasks_count", "boards_count", "repositories")
    end
  end
end
