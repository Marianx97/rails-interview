module Api
  class ItemsController < ApiController
    before_action :check_todo_list_present
    before_action :set_item, only: %i[show update destroy]

    # GET /api/todolists/:todo_list_id/items
    def index
      @items = Item.where(todo_list_id: params[:todo_list_id])
      respond_to :json
    end

    # GET /api/todolists/:todo_list_id/items/:id
    def show
      respond_to :json
    end

    # POST /api/todolists/:todo_list_id/items
    def create
      @item = Item.create!(item_params)
      respond_to :json
    end

    # PUT /api/todolists/:todo_list_id/items/:id
    def update
      @item.update!(item_params)
      respond_to :json
    end

    # DELETE /api/todolists/:todo_list_id/items/:id
    def destroy
      @item.destroy!
      respond_to :json
    end

    private

    def check_todo_list_present
      @todo_list = TodoList.find(params[:todo_list_id])
      raise ActiveRecord::RecordNotFound.new(
        "Couldn't find TodoList with id='#{params[:todo_list_id]}'"
      ) unless @todo_list.present?
    end

    def set_item
      @item = Item.find(params[:id])
      raise ActiveRecord::RecordNotFound.new(
        "Couldn't find Item with id='#{params[:id]}' for TodoList with id='#{@todo_list.id}'"
      ) unless @item.present?
    end

    def item_params
      item_params = params.require(:item).permit(:name, :description)
      item_params.merge(todo_list_id: params[:todo_list_id])
    end
  end
end
