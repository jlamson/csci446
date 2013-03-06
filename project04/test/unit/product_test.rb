require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  def new_product(image_url) 
  	Product.new(title: "Some Book",
                description: "lorum ipsum",
    						image_url: image_url,
                price: 1)
  end

  test "product attributes must not be empty" do 
  	product = Product.new
  	assert product.invalid?
  	[:title, :description, :image_url, :price].each { |field| assert product.errors[field].any? }
  end

  test "product price must be positive" do 
  	product = Product.new( title: "Some Book",
							             description: "lorum ipsum",
							             image_url: "fooBlah.jpg" )

  	product.price = -1
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

  	product.price = 0
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01",
		product.errors[:price].join('; ')

	product.price = 1
	assert product.valid?
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each { |name| assert new_product(name).valid?, "#{name} should be valid"}
    bad.each { |name| assert new_product(name).invalid?, "#{name} should be invalid"}
  end

end
