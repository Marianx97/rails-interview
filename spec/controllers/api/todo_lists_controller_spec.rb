require 'rails_helper'

describe Api::TodoListsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index, format: :html
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, format: :json

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, format: :json

        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(['id', 'name'])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe 'POST create' do
    context 'When name is invalid' do
      it 'returns an error code' do
        post :create, format: :json, params: { todo_list: { "name": "" } }

        expect(response.status).to eq(422)
      end

      it 'includes an error message' do
        post :create, format: :json, params: { todo_list: { "name": "" } }

        response_body = JSON.parse(response.body)

        expect(response_body['message']).to eq("Name can't be blank")
      end
    end

    context 'When name is valid' do
      it 'returns a success code' do
        post :create, format: :json, params: { todo_list: { "name": "test" } }

        expect(response.status).to eq(200)
      end

      it 'returns a valid response' do
        post :create, format: :json, params: { todo_list: { "name": "test" } }

        response_body = JSON.parse(response.body)

        expect(response_body['id']).to eq(1)
        expect(response_body['name']).to eq('test')
      end
    end
  end

  describe 'PUT update' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'When name is invalid' do
      it 'returns an error code' do
        put :update, format: :json, params: { id: 1, todo_list: { "name": "" } }

        expect(response.status).to eq(422)
      end

      it 'includes an error message' do
        put :update, format: :json, params: { id: 1, todo_list: { "name": "" } }

        response_body = JSON.parse(response.body)

        expect(response_body['message']).to eq("Name can't be blank")
      end
    end

    context 'When name is valid' do
      it 'returns a success code' do
        put :update, format: :json, params: { id: 1, todo_list: { "name": "test" } }

        expect(response.status).to eq(200)
      end

      it 'returns a valid response' do
        put :update, format: :json, params: { id: 1, todo_list: { "name": "test" } }

        response_body = JSON.parse(response.body)

        expect(response_body['id']).to eq(1)
        expect(response_body['name']).to eq('test')
      end
    end
  end
end
