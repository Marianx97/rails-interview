class ChangeTodoListItemsToItems < ActiveRecord::Migration[7.0]
  def change
    rename_table :todo_list_items, :items
  end
end
