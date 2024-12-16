require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "associations" do
    it { should have_many(:created_tasks).class_name('Task').with_foreign_key('creator_id').dependent(:nullify) }
    it { should have_many(:created_projects).class_name('Project').with_foreign_key('created_by_id').dependent(:nullify) }
    it { should have_many(:created_boards).class_name('Board').with_foreign_key('created_by_id').dependent(:nullify) }
    it { should have_many(:user_tasks) }
    it { should have_many(:assigned_tasks).through(:user_tasks).source(:task) }
    it { should have_many(:repositories).dependent(:nullify) }
  end

  describe "role enumeration" do
    it "responds to role helpers" do
      user = build(:user, :admin)
      expect(user.admin?).to be true
    end
  end

  describe "ransackable attributes" do
    it "returns the correct attributes" do
      expect(User.ransackable_attributes).to contain_exactly("id", "username", "email", "created_at", "updated_at")
    end
  end

  describe '#generate_jwt' do
    let(:user) { create(:user) }

    it 'generates a valid JWT token' do
      token = user.generate_jwt
      expect(token).not_to be_nil

      decoded_token = JsonWebToken.decode(token)
      expect(Time.zone.at(decoded_token[:exp])).to be > Time.current
    end
  end

  describe "password security" do
    it "encrypts the password" do
      user = create(:user, password: "securepassword")
      expect(user.authenticate("securepassword")).to eq(user)
      expect(user.authenticate("wrongpassword")).to be false
    end
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end
end