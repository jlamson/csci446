require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "product attributes must not be empty" do 
  	product = Product.new
  	assert product.invalid?
  	[:title, :description, :image_url, :price].each { |field| assert product.errors[field].any? }
  end

end
