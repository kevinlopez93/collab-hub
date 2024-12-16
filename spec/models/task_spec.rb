require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "associations" do
    it { should belong_to(:board) }
    it { should belong_to(:creator).class_name('User').with_foreign_key('creator_id') }
    it { should have_many(:user_tasks).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:task)).to be_valid
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct attributes' do
      expect(Task.ransackable_attributes).to eq([ 'id', 'title', 'description', 'workflow_status', 'created_at', 'updated_at' ])
    end
  end
end
