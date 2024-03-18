class ItemsController < ApplicationController
  before_action :check_todo_list_present
  before_action :set_item, only: %i[edit update show destroy]

  # GET /todolists/:todo_list_id/items
  def index
    @items = Item.where(todo_list_id: params[:todo_list_id])

    respond_to :html
  end

  # POST /todolists/:todo_list_id/items
  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to todo_list_items_path(@todo_list), notice: 'Item successfully created!'
    else
      flash.now[:alert] = 'Error creating item'
      render :new, status: :unprocessable_entity
    end
  end

  # GET /todolists/:todo_list_id/items/new
  def new
    @item = Item.new

    respond_to :html
  end

  # GET /todolists/:todo_list_id/items/:id/edit
  def edit
    respond_to :html
  end

  # GET /todolists/:todo_list_id/items/:id
  def show
    respond_to :html
  end

  # PUT /todolists/:todo_list_id/items/:id
  def update
    if @item.update(item_params)
      redirect_to todo_list_item_path, notice: 'Item successfully updated!'
    else
      flash.now[:alert] = 'Error updating item'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /todolists/:todo_list_id/items/:id
  def destroy
    @item.destroy
    redirect_to todo_list_items_path(@todo_list), notice: 'Item successfully deleted!', status: :see_other
  end

  private

  def check_todo_list_present
    @todo_list = TodoList.find(params[:todo_list_id])
    raise ActiveRecord::RecordNotFound unless @todo_list.present?
  end

  def set_item
    @item ||= Item.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @item.present?
  end

  def item_params
    item_params = params.require(:item).permit(:name, :description)
    item_params.merge(todo_list_id: params[:todo_list_id])
  end
end
