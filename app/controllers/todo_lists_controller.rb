class TodoListsController < ApplicationController
  before_action :set_todo_list, only: %i[edit update show destroy]

  # GET /todolists
  def index
    @todo_lists = TodoList.all

    respond_to :html
  end

  # POST /todolists
  def create
    @todo_list = TodoList.new(todo_list_params)

    if @todo_list.save
      redirect_to todo_lists_path, notice: 'List successfully created!'
    else
      flash.now[:alert] = 'Error creating list'
      render :new, status: :unprocessable_entity
    end
  end

  # GET /todolists/new
  def new
    @todo_list = TodoList.new

    respond_to :html
  end

  # GET /todolists/:id/edit
  def edit
    respond_to :html
  end

  # GET /todolists/:id
  def show
    respond_to :html
  end

  # PUT /todolists/:id
  def update
    if @todo_list.update(todo_list_params)
      redirect_to todo_list_path, notice: 'List successfully updated!'
    else
      flash.now[:alert] = 'Error updating list'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /todolists/:id
  def destroy
    @todo_list.destroy
    redirect_to todo_lists_path, notice: 'List successfully deleted!', status: :see_other
  end

  private

  def set_todo_list
    @todo_list ||= TodoList.find(params[:id])
  end

  def todo_list_params
    params.require(:todo_list).permit(:name)
  end
end
