require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  def new_product(image_url)
    Product.new(
      title:       "My Book Title",
      description: "yyy",
      price:       1,
      image_url: image_url
      )
  end

  test "product attributes must not be empty" do
    product = Product.new
    properties = [:title, :description, :price, :image_url]

    assert product.invalid?
    properties.each do |property|
      assert product.errors[property].any?
    end
  end

  test "product price must be positive" do
    product = Product.new(
      title: "My Book Title",
      description: "yyy",
      image_url: "zzz.jpg"
      )
    invalid_prices = [0, -1]
    invalid_prices.each do |price|
      product.price = price
      assert product.invalid?
      assert_equal ["must be greater than or equal to 0.01"],
        product.errors[:price]
    end
    product.price = 1
    assert product.valid?
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.JPG
              http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(
        title: products(:ruby).title,
        description: "yyy",
        price: 1,
        image_url: "fred.gif"
      )
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "Product should return latest product" do
    product = Product.create(
      title: "basketball",
      description: "It's a ball that bounces, what more do you want?",
      price: 15,
      image_url: "basketball.jpg"
      )
    assert_equal Product.latest, product
  end
end
