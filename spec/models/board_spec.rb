require 'rails_helper'

RSpec.describe Board, type: :model do
  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:created_by).class_name('User').with_foreign_key('created_by_id') }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:board)).to be_valid
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct attributes' do
      expect(Board.ransackable_attributes).to eq(['id', 'name', 'created_at', 'updated_at'])
    end
  end
end
