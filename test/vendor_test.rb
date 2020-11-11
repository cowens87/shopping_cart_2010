require "minitest/autorun"
require "minitest/pride"
require "./lib/item"
require "./lib/vendor"

class VendorTest < Minitest::Test
  # Iteration 1
  def setup
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end 

  def test_it_exists_and_has_attributes
    assert_instance_of Vendor, @vendor
    assert_equal "Rocky Mountain Fresh", @vendor.name
  end

  def test_it_can_store_inventory
    expected = {}
    assert_equal expected, @vendor.inventory
  end
end