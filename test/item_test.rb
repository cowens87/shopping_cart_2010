require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'

class Test < Minitest::Test
  # Iteration 1
  def setup
    @item1 = Item.new({name: 'Peach', price: '$0.75'})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
  end

  def test_it_exists_and_has_attributes
      assert_instance_of Item, @item2
    assert_equal 'Tomato', @item2.name
    assert_equal 0.5, @item2.price
  end
end