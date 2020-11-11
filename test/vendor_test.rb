require "minitest/autorun"
require "minitest/pride"
require "./lib/item"
require "./lib/vendor"

class VendorTest < Minitest::Test
  # Iteration 1
  def setup
    @vendor = Vendor.new("Rocky Mountain Fresh")
    @vendor1 = Vendor.new('Rocky Mountain Fresh')
    @vendor2 = Vendor.new('Ba-Nom-a-Nom')
    @vendor3 = Vendor.new('Palisade Peach Shack')
    @item1 = Item.new({name: 'Peach', price: '$0.75'})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: 'Peach-Raspberry Nice Cream', price: '$5.30'})
    @item4 = Item.new({name: 'Banana Nice Cream', price: '$4.25'})
  end 

  def test_it_exists_and_has_attributes
    assert_instance_of Vendor, @vendor
    assert_equal "Rocky Mountain Fresh", @vendor.name
  end

  def test_inventory_starts_empty
    expected = {}
    assert_equal expected, @vendor.inventory
  end

  def test_it_can_check_stock
    assert_equal 0, @vendor.check_stock(@item1)
  end

  def test_it_can_stock_items
    @vendor.stock(@item1, 30)

    expected = {@item1 => 30}
    assert_equal expected, @vendor.inventory

    assert_equal 30, @vendor.check_stock(@item1)

    @vendor.stock(@item1, 25)

    assert_equal 55, @vendor.check_stock(@item1)

    @vendor.stock(@item2, 12)

    expected = {@item1 => 55, @item2 => 12}
    assert_equal expected, @vendor.inventory
  end

  # End of Iteration 2
  def test_it_can_find_potential_revenue
  # A Vendor will be able to calculate their `potential_revenue` -
  # the sum of all their items' price * quantity.
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal 29.75, @vendor1.potential_revenue
    assert_equal 345.00, @vendor2.potential_revenue
    assert_equal 48.75, @vendor3.potential_revenue
  end
end