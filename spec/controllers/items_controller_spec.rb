require 'rails_helper'

describe ItemsController, type: :controller do
  let(:todo_list) { TodoList.create(name: 'Items List') }
  let(:valid_attributes) { { name: 'Test Item', description: 'Test Description' } }
  let(:invalid_attributes) { { name: nil, description: 'Test Description' } }
  let(:item) { Item.create(name: 'Item name', description: 'Item desc', todo_list: todo_list) }

  describe 'GET #index' do
    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :index, params: { todo_list_id: todo_list.id }, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'assigns all items as @items' do
        get :index, params: { todo_list_id: todo_list.id }, format: :html
        expect(assigns(:items)).to eq([item])
      end
    end
  end

  describe 'POST #create' do
    context 'when format is HTML' do
      context 'with valid params' do
        it 'creates a new Item' do
          expect {
            post :create, params: { todo_list_id: todo_list.id, item: valid_attributes }, format: :html
          }.to change(Item, :count).by(1)
        end

        it 'redirects to the created item' do
          post :create, params: { todo_list_id: todo_list.id, item: valid_attributes }, format: :html
          expect(response).to redirect_to(todo_list_items_path(todo_list))
        end
      end

      context 'with invalid params' do
        it 'renders the :new template with unprocessable entity status' do
          post :create, params: { todo_list_id: todo_list.id, item: invalid_attributes }, format: :html
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :new, params: { todo_list_id: todo_list.id }, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'assigns a new item as @item' do
        get :new, params: { todo_list_id: todo_list.id }, format: :html
        expect(assigns(:item)).to be_a_new(Item)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #edit' do
    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :edit, params: { todo_list_id: todo_list.id, id: item.id }, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'assigns the requested item as @item' do
        get :edit, params: { todo_list_id: todo_list.id, id: item.id }, format: :html
        expect(assigns(:item)).to eq(item)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    context 'when format is JSON' do
      it 'raises a routing error' do
        expect {
          get :show, params: { todo_list_id: todo_list.id, id: item.id }, format: :json
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is HTML' do
      it 'assigns the requested item as @item' do
        get :show, params: { todo_list_id: todo_list.id, id: item.id }
        expect(assigns(:item)).to eq(item)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT #update' do
    context 'when format is HTML' do
      context 'with valid params' do
        let(:new_attributes) { { name: 'New Name' } }

        it 'updates the requested item' do
          put :update, params: { todo_list_id: todo_list.id, id: item.to_param, item: new_attributes }
          item.reload
          expect(item.name).to eq('New Name')
        end

        it 'redirects to the item' do
          put :update, params: { todo_list_id: todo_list.id, id: item.to_param, item: valid_attributes }
          expect(response).to redirect_to(todo_list_item_path(assigns(:todo_list), item))
        end
      end

      context 'with invalid params' do
        it 'renders the :edit template with unprocessable entity status' do
          put :update, params: { todo_list_id: todo_list.id, id: item.to_param, item: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when format is HTML' do
      it 'destroys the requested item' do
        item = Item.create(name: 'Item name', description: 'Item desc', todo_list: todo_list)
        expect {
          delete :destroy, params: { todo_list_id: todo_list.id, id: item.id }
        }.to change(Item, :count).by(-1)
      end

      it 'redirects to the items list' do
        delete :destroy, params: { todo_list_id: todo_list.id, id: item.id }
        expect(response).to redirect_to(todo_list_items_path(todo_list))
      end
    end
  end
end
