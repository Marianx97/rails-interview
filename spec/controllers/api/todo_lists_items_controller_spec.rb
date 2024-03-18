require 'rails_helper'

describe Api::ItemsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'ToDo List #1') }
    let!(:todo_list_item) do
      Item.create(
        name: 'Item #1',
        description: 'First item',
        todo_list_id: todo_list.id
      )
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index, format: :html, params: { todo_list_id: todo_list.id }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when todo list does not exist' do
        it 'returns an error code' do
          get :index, format: :json, params: { todo_list_id: (todo_list.id + 1) }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          get :index, format: :json, params: { todo_list_id: (todo_list.id + 1) }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=#{todo_list.id + 1}")
        end
      end

      context 'when todo list exists' do
        it 'returns a success code' do
          get :index, format: :json, params: { todo_list_id: todo_list.id }

          expect(response.status).to eq(200)
        end

        it 'includes todo list items records' do
          get :index, format: :json, params: { todo_list_id: todo_list.id }

          todo_list_items = JSON.parse(response.body)

          aggregate_failures 'includes the id and name' do
            expect(todo_list_items.count).to eq(1)
            expect(todo_list_items[0].keys).to match_array(['id', 'name'])
            expect(todo_list_items[0]['id']).to eq(todo_list_item.id)
            expect(todo_list_items[0]['name']).to eq(todo_list_item.name)
          end
        end
      end
    end
  end

  describe 'POST create' do
    let!(:todo_list) { TodoList.create(name: 'ToDo List #1') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          post :create, format: :html, params: {
            todo_list_id: todo_list.id,
            item: {
              "name": "New Item",
              "description": "New item for todo list"
            }
          }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when todo list does not exist' do
        it 'returns an error code' do
          post :create, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            item: {
              "name": "New Item",
              "description": "New item for todo list"
            }
          }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          post :create, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            item: {
              "name": "New Item",
              "description": "New item for todo list"
            }
          }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=#{todo_list.id + 1}")
        end
      end

      context 'when todo list exists' do
        context 'when params are invalid' do
          it 'returns an error code' do
            post :create, format: :json, params: {
              todo_list_id: todo_list.id,
              item: { "name": "", "description": "" }
            }

            expect(response.status).to eq(422)
          end

          it 'returns an error message' do
            post :create, format: :json, params: {
              todo_list_id: todo_list.id,
              item: { "name": "", "description": "" }
            }

            response_body = JSON.parse(response.body)

            expect(response_body['message']).to eq("Name can't be blank and Description can't be blank")
          end
        end

        context 'when params are valid' do
          it 'returns a success code' do
            post :create, format: :json, params: {
              todo_list_id: todo_list.id,
              item: {
                "name": "New Item",
                "description": "New item for todo list"
              }
            }

            expect(response.status).to eq(200)
          end

          it 'returns a valid response' do
            post :create, format: :json, params: {
              todo_list_id: todo_list.id,
              item: {
                "name": "New Item",
                "description": "New item for todo list"
              }
            }

            response_body = JSON.parse(response.body)

            expect(response_body.keys).to match_array(%w[id name description created_at updated_at])
            expect(response_body['id']).to eq(1)
            expect(response_body['name']).to eq('New Item')
            expect(response_body['description']).to eq('New item for todo list')
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let!(:todo_list) { TodoList.create(name: 'ToDo List #1') }
    let!(:todo_list_item) do
      Item.create(
        name: 'Item #1',
        description: 'First item',
        todo_list_id: todo_list.id
      )
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          put :update, format: :html, params: {
            todo_list_id: todo_list.id,
            id: todo_list_item.id,
            item: { "name": "New name" }
          }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when todo list does not exist' do
        it 'returns an error code' do
          put :update, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            id: todo_list_item.id,
            item: { "name": "New name" }
          }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          put :update, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            id: todo_list_item.id,
            item: { "name": "New name" }
          }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=#{todo_list.id + 1}")
        end
      end

      context 'when todo list exists' do
        context 'when params are invalid' do
          it 'returns an error code' do
            put :update, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id,
              item: { "name": "", "description": "" }
            }

            expect(response.status).to eq(422)
          end

          it 'returns an error message' do
            put :update, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id,
              item: { "name": "", "description": "" }
            }

            response_body = JSON.parse(response.body)

            expect(response_body['message']).to eq("Name can't be blank and Description can't be blank")
          end
        end

        context 'when params are valid' do
          it 'returns a success code' do
            put :update, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id,
              item: {
                "name": "New name",
                "description": "New description"
              }
            }

            expect(response.status).to eq(200)
          end

          it 'returns a valid response' do
            put :update, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id,
              item: {
                "name": "New name",
                "description": "New description"
              }
            }

            response_body = JSON.parse(response.body)

            expect(response_body.keys).to match_array(%w[id name description created_at updated_at])
            expect(response_body['id']).to eq(1)
            expect(response_body['name']).to eq('New name')
            expect(response_body['description']).to eq('New description')
          end
        end
      end
    end
  end

  describe 'GET show' do
    let!(:todo_list) { TodoList.create(name: 'ToDo List #1') }
    let!(:todo_list_item) do
      Item.create(
        name: 'Item #1',
        description: 'First item',
        todo_list_id: todo_list.id
      )
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :show, format: :html, params: {
            todo_list_id: todo_list.id,
            id: todo_list_item.id
          }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when todo list does not exist' do
        it 'returns an error code' do
          get :show, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            id: todo_list_item.id
          }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          get :show, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            id: todo_list_item.id
          }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=#{todo_list.id + 1}")
        end
      end

      context 'when todo list exists' do
        context 'when there is no record for the given id' do
          it 'returns an error code' do
            get :show, format: :json, params: {
              todo_list_id: todo_list.id,
              id: (todo_list_item.id + 1)
            }

            expect(response.status).to eq(404)
          end

          it 'includes an error message' do
            get :show, format: :json, params: {
              todo_list_id: todo_list.id,
              id: (todo_list_item.id + 1)
            }

            response_body = JSON.parse(response.body)

            expect(response_body['message']).to eq("Couldn't find Item with 'id'=#{todo_list_item.id + 1}")
          end
        end

        context 'when there is a record for the given id' do
          it 'returns a success code' do
            get :show, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id
            }

            expect(response.status).to eq(200)
          end

          it 'includes a valid response' do
            get :show, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id
            }

            response_body = JSON.parse(response.body)

            expect(response_body['id']).to eq(1)
            expect(response_body['name']).to eq('Item #1')
            expect(response_body['description']).to eq('First item')
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:todo_list) { TodoList.create(name: 'ToDo List #1') }
    let!(:todo_list_item) do
      Item.create(
        name: 'Item #1',
        description: 'First item',
        todo_list_id: todo_list.id
      )
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          delete :destroy, format: :html, params: {
            todo_list_id: todo_list.id,
            id: todo_list_item.id
          }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context 'when todo list does not exist' do
        it 'returns an error code' do
          delete :destroy, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            id: todo_list_item.id
          }

          expect(response.status).to eq(404)
        end

        it 'includes an error message' do
          delete :destroy, format: :json, params: {
            todo_list_id: (todo_list.id + 1),
            id: todo_list_item.id
          }

          response_body = JSON.parse(response.body)

          expect(response_body['message']).to eq("Couldn't find TodoList with 'id'=#{todo_list.id + 1}")
        end
      end

      context 'when todo list exists' do
        context 'when there is no record for the given id' do
          it 'returns an error code' do
            delete :destroy, format: :json, params: {
              todo_list_id: todo_list.id,
              id: (todo_list_item.id + 1)
            }

            expect(response.status).to eq(404)
          end

          it 'includes an error message' do
            delete :destroy, format: :json, params: {
              todo_list_id: todo_list.id,
              id: (todo_list_item.id + 1)
            }

            response_body = JSON.parse(response.body)

            expect(response_body['message']).to eq("Couldn't find Item with 'id'=#{todo_list_item.id + 1}")
          end
        end

        context 'when there is a record for the given id' do
          it 'returns a success code' do
            delete :destroy, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id
            }

            expect(response.status).to eq(200)
          end

          it 'includes a valid response' do
            delete :destroy, format: :json, params: {
              todo_list_id: todo_list.id,
              id: todo_list_item.id
            }

            response_body = JSON.parse(response.body)

            expect(response_body['message']).to eq('Record successfully deleted')
          end
        end
      end
    end
  end
end
