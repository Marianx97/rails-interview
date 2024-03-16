module Api
  class TodoListsItemsController < ApiController
    before_action :check_todo_list_present
    before_action :set_todo_list_item, only: %i[show update destroy]

    # GET /api/todolists/:todo_list_id/items
    def index
      @todo_list_items = TodoListItem.where(todo_list_id: params[:todo_list_id])
      respond_to :json
    end

    # GET /api/todolists/:todo_list_id/items/:id
    def show
      respond_to :json
    end

    # POST /api/todolists/:todo_list_id/items
    def create
      @todo_list_item = TodoListItem.create!(todo_list_item_params)
      respond_to :json
    end

    # PUT /api/todolists/:todo_list_id/items/:id
    def update
      @todo_list_item.update!(todo_list_item_params)
      respond_to :json
    end

    # DELETE /api/todolists/:todo_list_id/items/:id
    def destroy
      @todo_list_item.destroy!
      respond_to :json
    end

    private

    def check_todo_list_present
      @todo_list = TodoList.find(params[:todo_list_id])
      raise ActiveRecord::RecordNotFound.new(
        "Couldn't find TodoList with id='#{params[:todo_list_id]}'"
      ) unless @todo_list.present?
    end

    def set_todo_list_item
      @todo_list_item = @todo_list.todo_list_items.find_by_id(params[:id])
      raise ActiveRecord::RecordNotFound.new(
        "Couldn't find TodoListItem with id='#{params[:id]}' for TodoList with id='#{@todo_list.id}'"
      ) unless @todo_list_item.present?
    end

    def todo_list_item_params
      item_params = params.require(:todo_lists_item).permit(:name, :description)
      item_params.merge(todo_list_id: params[:todo_list_id])
    end
  end
end
