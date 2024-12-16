require 'rails_helper'

RSpec.describe UserTask, type: :model do
  describe "associations" do
    it { should belong_to(:task) }
    it { should belong_to(:user) }
  end
end
