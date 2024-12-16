require "rails_helper"

RSpec.describe Tasks::UpdateStates, type: :service do
  let(:user) { create(:user) }
  let(:task) { create(:task, creator: user, workflow_status: TaskStatus::TODO) }

  describe "#call" do
    context "when event is not provided" do
      it "returns error response with no event provided message" do
        service = Tasks::UpdateStates.new(task, nil)

        result = service.call

        expect(result[:result]).to be_falsey
        expect(result[:errors]).to eq("No event provided")
      end
    end

    context "when invalid event is provided" do
      it "returns error response with invalid event message" do
        service = Tasks::UpdateStates.new(task, "invalid_event")

        result = service.call

        expect(result[:result]).to be_falsey
        expect(result[:errors]).to eq("Invalid event")
      end
    end

    context "when valid event is provided and state transition is valid" do
      it "updates task state and returns success" do
        allow(task).to receive(:may_to_start?).and_return(true)
        service = Tasks::UpdateStates.new(task, "to_start")

        result = service.call

        expect(result[:result]).to be_truthy
        expect(task.workflow_status).to eq(TaskStatus::IN_PROGRESS)
      end
    end

    context "when valid event is provided but state transition is not allowed" do
      it "returns error response with invalid state transition message" do
        service = Tasks::UpdateStates.new(task, "invalid")

        result = service.call

        expect(result[:result]).to be_falsey
        expect(result[:errors]).to eq("Invalid event")
      end
    end
  end
end
