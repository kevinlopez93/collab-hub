require "rails_helper"

RSpec.describe Projects::Update, type: :service do
  let(:user) { create(:user) }
  let(:project) { create(:project, created_by: user) }
  let(:repositories) { create_list(:repository, 2, project: project, user: user) }
  let(:updated_params) { { name: "Updated Project", description: "Updated description" } }
  let(:repositories_assigned) { repositories.pluck(:id) }

  describe "#call" do
    context "when updating project and repositories" do
      it "updates the project and assigns repositories" do
        service = Projects::Update.new(project, updated_params, repositories_assigned)

        service.call

        # Verify that the project has been updated
        project.reload
        expect(project.name).to eq("Updated Project")
        expect(project.description).to eq("Updated description")

        # Verify that the repositories have been assigned to the project
        expect(repositories.first.reload.project_id).to eq(project.id)
        expect(repositories.last.reload.project_id).to eq(project.id)
      end
    end

    context "when no repositories are assigned" do
      it "updates the project only" do
        service = Projects::Update.new(project, updated_params)

        service.call

        # Verify that the project has been updated
        project.reload
        expect(project.name).to eq("Updated Project")
        expect(project.description).to eq("Updated description")
      end
    end

    context "when the project update fails" do
      it "does not update repositories" do
        invalid_params = { name: "" } # Assuming name is required
        service = Projects::Update.new(project, invalid_params, repositories_assigned)

        service.call

        # Verify that the project was not updated
        project.reload
        expect(project.name).not_to eq("")
        expect(project.errors[:name]).to include("can't be blank")
      end
    end
  end
end