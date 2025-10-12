require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password") }

  it "is valid with a title and description" do
    todo = Todo.new(title: "Finish assignment", description: "Complete the Rails CI/CD setup", user: user)
    expect(todo).to be_valid
  end

  it "is invalid without a title" do
    todo = Todo.new(description: "This has no title", user: user)
    expect(todo).not_to be_valid
  end

  it "can be saved and retrieved from the database" do
    todo = Todo.create!(title: "Test persistence", description: "Check DB save", user: user)
    fetched_todo = Todo.find_by(title: "Test persistence")

    expect(fetched_todo).not_to be_nil
    expect(fetched_todo.description).to eq("Check DB save")
    expect(fetched_todo.user).to eq(user)
  end
end
