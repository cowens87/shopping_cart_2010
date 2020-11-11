require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'date'
require './lib/market'
require './lib/vendor'
require './lib/item'
# Iteration 2
class MarketTest < Minitest::Test
  def setup
    @market  = Market.new('South Pearl Street Farmers Market')
    @vendor1 = Vendor.new('Rocky Mountain Fresh')
    @vendor2 = Vendor.new('Ba-Nom-a-Nom')
    @vendor3 = Vendor.new('Palisade Peach Shack')
    @item1   = Item.new({name: 'Peach', price: '$0.75'})
    @item2   = Item.new({name: 'Tomato', price: '$0.50'})
    @item3   = Item.new({name: 'Peach-Raspberry Nice Cream', price: '$5.30'})
    @item4   = Item.new({name: 'Banana Nice Cream', price: '$4.25'})
    @item5   = Item.new({name: 'Onion', price: '$0.25'})
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Market, @market
    assert_equal 'South Pearl Street Farmers Market', @market.name
  end

  def test_it_starts_with_no_vendors
    assert_equal [], @market.vendors
  end

  def test_it_can_add_vendors
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
  end

  def test_it_can_list_vendor_names
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    
    expected = ['Rocky Mountain Fresh', 'Ba-Nom-a-Nom', 'Palisade Peach Shack']
    assert_equal expected, @market.vendor_names
  end

  def test_it_can_list_vendor_that_sell_item
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)
    assert_equal [@vendor2], @market.vendors_that_sell(@item4)
  end
  # Iteration 3
  #### total inventory helper method ####
  def test_it_can_find_the_total_quantity
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal 100, @market.total_quantity(@item1)
    assert_equal 35, @market.total_quantity(@item3)
  end

  def test_it_list_total_inventory
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expected =  {
                @item1 => {quantity: 100, vendors: [@vendor1, @vendor3]},
                @item2 => {quantity: 7, vendors: [@vendor1]},
                @item4 => {quantity: 50, vendors: [@vendor2]},
                @item3 => {quantity: 35, vendors: [@vendor2, @vendor3]},
                }
    assert_equal expected, @market.total_inventory
  end

  def test_item_is_overstocked
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@item1], @market.overstocked_items
  end

  def test_it_can_list_sorted_items
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expected = ['Banana Nice Cream', 'Peach', 'Peach-Raspberry Nice Cream', 'Tomato']
    assert_equal expected, @market.sorted_item_list
  end
  # Iteration 4
  def test_it_can_find_the_date
    Date.stubs(:today).returns(Date.parse("20200224"))
    market = Market.new("South Pearl Street Farmers Market")
    assert_equal "24/02/2020", market.date
  end

  def test_it_can_sell_an_item
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal false, @market.sell(@item1, 200)
    assert_equal false, @market.sell(@item5, 1)
    assert_equal true, @market.sell(@item4, 5)
    assert_equal 45, @vendor2.check_stock(@item4)
    assert_equal true, @market.sell(@item1, 40)
    assert_equal 0, @vendor1.check_stock(@item1)
    assert_equal 60, @vendor3.check_stock(@item1)
  end
end
