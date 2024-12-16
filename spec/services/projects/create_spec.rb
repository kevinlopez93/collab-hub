require "rails_helper"

RSpec.describe Projects::Create, type: :service do
  let(:user) { create(:user) }
  let(:project_params) { { name: "New Project", description: "A test project" } }

  describe "#call" do
    context "when called with valid parameters" do
      it "creates a new project associated with the current user" do
        service = Projects::Create.new(project_params, user)
        project = service.call

        expect(project).to be_persisted
        expect(project.name).to eq("New Project")
        expect(project.description).to eq("A test project")
        expect(project.created_by).to eq(user)
      end
    end

    context "when called with invalid parameters" do
      it "does not create a project and returns an invalid project" do
        invalid_params = { name: nil }
        service = Projects::Create.new(invalid_params, user)
        project = service.call

        expect(project).not_to be_persisted
        expect(project.errors[:name]).to include("can't be blank") # Adjust based on your validations
      end
    end
  end
end