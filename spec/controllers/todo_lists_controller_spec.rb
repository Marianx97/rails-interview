require 'rails_helper'

describe TodoListsController, type: :controller do
  describe 'GET #index' do
    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :index, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'assigns all todo lists to @todo_lists' do
        get :index, format: :html
        expect(assigns(:todo_lists)).to eq(TodoList.all)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    let!(:todo_list_params) { { name: 'Test List' } }

    context 'when format is HTML' do
      context 'when name is invalid' do
        it 'does not create a new todo list' do
          expect {
            post :create, params: { todo_list: { name: '' } }, format: :html
          }.not_to change(TodoList, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when name is valid' do
        it 'creates a new todo list' do
          expect {
            post :create, params: { todo_list: todo_list_params }, format: :html
          }.to change(TodoList, :count).by(1)

          expect(response).to redirect_to(todo_lists_path)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :new, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'assigns a new todo list to @todo_list' do
        get :new, format: :html
        expect(assigns(:todo_list)).to be_a_new(TodoList)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #edit' do
    let!(:todo_list) { TodoList.create(name: 'Edit List') }

    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :edit, params: { id: todo_list.id }, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'renders the edit template' do
        get :edit, params: { id: todo_list.id }, format: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    let!(:todo_list) { TodoList.create(name: 'Show List') }

    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :show, params: { id: todo_list.id }, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'renders the show template' do
        get :show, params: { id: todo_list.id }, format: :html
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT #update' do
    context 'when format is HTML' do
      context 'when name is invalid' do
        it 'does not update the todo list' do
          todo_list = TodoList.create(name: 'Update List')
          new_name = ''

          put :update, params: { id: todo_list.id, todo_list: { name: new_name } }, format: :html
          todo_list.reload

          expect(todo_list.name).to eq('Update List')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when name is valid' do
        it 'updates the todo list' do
          todo_list = TodoList.create(name: 'Update List')
          new_name = 'Updated List'

          put :update, params: { id: todo_list.id, todo_list: { name: new_name } }, format: :html
          todo_list.reload

          expect(todo_list.name).to eq(new_name)
          expect(response).to redirect_to(todo_list_path(todo_list))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when format is HTML' do
      it 'deletes the todo list' do
        todo_list = TodoList.create(name: 'Delete List')

        expect {
          delete :destroy, params: { id: todo_list.id }, format: :html
        }.to change(TodoList, :count).by(-1)

        expect(response).to redirect_to(todo_lists_path)
      end
    end
  end
end
