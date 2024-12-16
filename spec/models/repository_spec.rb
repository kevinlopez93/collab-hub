require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe "associations" do
    it { should belong_to(:project).optional }
    it { should belong_to(:user).optional }
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:repository)).to be_valid
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct attributes' do
      expect(Repository.ransackable_attributes).to eq(['id', 'name', 'created_at', 'updated_at', 'remote_id', 'node_id', 'full_name', 'owner_login', 'description', 'url_api', 'url_html', 'remote_created_at', 'remote_updated_at', 'visibility', 'language'])
    end
  end
end
