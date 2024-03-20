class Item < ApplicationRecord
  validates :name, presence: :true, length: { maximum: 40 }
  validates :description, presence: :true, length: { maximum: 200 }

  belongs_to :todo_list
end
