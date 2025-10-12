require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with an email and password" do
    user = User.new(email: "test@example.com", password: "123456")
    expect(user).to be_valid
  end

  it "is invalid without an email" do
    user = User.new(password: "123456")
    expect(user).not_to be_valid
  end
end
