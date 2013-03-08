class Cart < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :line_item, dependent: :destroy
end
