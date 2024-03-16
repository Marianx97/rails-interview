class TodoList < ApplicationRecord
  validates :name, presence: :true, uniqueness: :true

  has_many :todo_list_items, dependent: :destroy
end
