# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "associations" do
    it { should belong_to(:created_by).class_name('User').with_foreign_key('created_by_id') }
    it { should have_many(:boards).dependent(:destroy) }
    it { should have_many(:tasks) }
    it { should have_many(:repositories).dependent(:nullify) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:project)).to be_valid
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct attributes' do
      expect(Project.ransackable_attributes).to eq(['id', 'name', 'created_at', 'updated_at'])
    end
  end
end