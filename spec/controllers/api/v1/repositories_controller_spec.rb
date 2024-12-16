require "rails_helper"

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:project) { create(:project, created_by: user) }
  let!(:repositories) { create_list(:repository, 2, project: project, user: user) }

  describe "GET #index" do
    it "returns http unauthorized" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success" do
      login user
      get :index
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(2)
    end

    it "returns http success with filter params" do
      login user
      get :index, params: { q: { name_cont: repositories.first.name } }
      expect(response).to have_http_status(:success)
      expect(json.length).to eq(1)
    end
  end
end
