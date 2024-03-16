module Api
  class TodoListsController < ApiController
    before_action :set_todo_list, only: %i[show update destroy]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all
      respond_to :json
    end

    # GET /api/todolists/:id
    def show
      respond_to :json
    end

    # POST /api/todolists
    def create
      @todo_list = TodoList.create!(todo_list_params)
      respond_to :json
    end

    # PUT /api/update
    def update
      @todo_list.update!(todo_list_params)
      respond_to :json
    end

    # DELETE /api/todolists/:id
    def destroy
      @todo_list.destroy!
      respond_to :json
    end

    private

    def set_todo_list
      @todo_list = TodoList.find(params[:id])
    end

    def todo_list_params
      params.require(:todo_list).permit(:name)
    end
  end
end
