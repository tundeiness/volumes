require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  it 'is valid with valid attributes' do
    user = User.new(name: 'John Doe', email: 'john@example.com')
    expect(user).to be_valid
  end
end
