module Api
  class TodoListsController < ApiController
    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    # POST /api/todolists
    def create
      @todo_list = TodoList.create!(todo_list_params)
      respond_to :json
    end

    # PUT /api/update
    def update
      @todo_list = TodoList.find(params[:id])
      @todo_list.update!(todo_list_params)
      respond_to :json
    end

    private

    def todo_list_params
      params.require(:todo_list).permit(:name)
    end
  end
end
