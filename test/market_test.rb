require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'date'
require './lib/market'
require './lib/item'
require './lib/vendor'
# Iteration 2
class MarketTest < Minitest::Test
  def setup
    @market = Market.new('South Pearl Street Farmers Market')
    @vendor1 = Vendor.new('Rocky Mountain Fresh')
    @vendor2 = Vendor.new('Ba-Nom-a-Nom')
    @vendor3 = Vendor.new('Palisade Peach Shack')
    @item1 = Item.new({name: 'Peach', price: '$0.75'})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: 'Peach-Raspberry Nice Cream', price: '$5.30'})
    @item4 = Item.new({name: 'Banana Nice Cream', price: '$4.25'})
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
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
    assert_equal ['Rocky Mountain Fresh', 'Ba-Nom-a-Nom', 'Palisade Peach Shack'], @market.vendor_names
  end

  def test_it_can_list_vendor_that_sell_item
  # the Market should have a method called `vendors_that_sell` that takes an
  # argument of an item represented as a String. It will return a list of Vendors
  # that have that item in stock.
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
  end

  def test_it_list_total_inventory
  # Additionally, your `Market` class should have a method called `total_inventory`
  # that reports the quantities of all items sold at the market. Specifically,
  # it should return a hash with items as keys and hash as values - this sub-hash 
  # should have two key/value pairs: quantity pointing to total inventory for that
  # item and vendors pointing to an array of the vendors that sell that item.
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
  # You `Market` will also be able to identify `overstocked_items`.
  # An item is overstocked if it is sold by more than 1 vendor AND the total
  # quantity is greater than 50.
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
  # Add a method to your `Market` class called `sorted_item_list` that returns a
  # list of names of all items the Vendors have in stock, sorted alphabetically.
  # This list should not include any duplicate items.
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
  # A market will now be created with a date - whatever date the market is
  # created on through the use of `Date.today`. The addition of a date to the
  # market should NOT break any previous tests.  The `date` method will return
  # a string representation of the date - 'dd/mm/yyyy'. We want you to test this
  # in with a date that is IN THE PAST. In order to test the date method in a
  # way that will work today, tomorrow and on any date in the future, you will
  # need to use a stub :)
    Date.stubs(:today).returns(Date.parse("20200224"))
    assert_equal "24/02/2020", @market.date
  end
end
