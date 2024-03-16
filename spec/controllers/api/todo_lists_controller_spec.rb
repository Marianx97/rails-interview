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
    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          post :create, format: :html, params: { todo_list: { "name": "test" } }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when name is invalid' do
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

      context 'when name is valid' do
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
  end

  describe 'PUT update' do
    context 'when format is HTML' do
      let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

      it 'raises a routing error' do
        expect {
          put :update, format: :html, params: { id: 1, todo_list: { "name": "test" } }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when there is no record for the given id' do
        it 'returns an error code' do
          put :update, format: :json, params: { id: 1, todo_list: { "name": "new name" } }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          put :update, format: :json, params: { id: 1, todo_list: { "name": "new name" } }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=1")
        end
      end

      context 'when there is a record for the given id' do
        let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

        context 'when name is invalid' do
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

        context 'when name is valid' do
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
  end

  describe 'GET show' do
    context 'when format is HTML' do
      let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

      it 'raises a routing error' do
        expect {
          get :show, format: :html, params: { id: 1 }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when there is no record for the given id' do
        it 'returns an error code' do
          get :show, format: :json, params: { id: 1 }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          get :show, format: :json, params: { id: 1 }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=1")
        end
      end

      context 'when there is a record for the given id' do
        let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

        it 'returns an success code' do
          get :show, format: :json, params: { id: 1 }

          expect(response.status).to eq(200)
        end

        it 'includes a valid response' do
          get :show, format: :json, params: { id: 1 }

          response_body = JSON.parse(response.body)

          expect(response_body['id']).to eq(1)
          expect(response_body['name']).to eq('Setup RoR project')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when format is HTML' do
      let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

      it 'raises a routing error' do
        expect {
          delete :destroy, format: :html, params: { id: 1 }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when there is no record for the given id' do
        it 'returns an error code' do
          delete :destroy, format: :json, params: { id: 1 }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          delete :destroy, format: :json, params: { id: 1 }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=1")
        end
      end

      context 'when there is a record for the given id' do
        let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

        it 'returns an success code' do
          delete :destroy, format: :json, params: { id: 1 }

          expect(response.status).to eq(200)
        end

        it 'includes a valid response' do
          delete :destroy, format: :json, params: { id: 1 }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq('Record successfully deleted')
        end
      end
    end
  end
end
