class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[show edit update destroy]

  def index
    @todos = current_user.todos
  end

  def show; end

  def new
    @todo = current_user.todos.build
  end

  def edit; end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      redirect_to todos_path, notice: "Todo was successfully created."
    else
      render :new
    end
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "Todo was successfully deleted."
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed)
  end
end
