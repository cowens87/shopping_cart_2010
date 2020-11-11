class Market
 attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.collect do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.select do |vendor|
      vendor.inventory.include?(item)
    end
  end

# Iteration 3
  def total_quantity(item)
    vendors_that_sell(item).sum do |vendor|
      vendor.inventory[item]
    end
  end

  def total_inventory
    @vendors.each_with_object({}) do |vendor, inventory|
      vendor.inventory.each do |item, amount|
        inventory[item] = {quantity: total_quantity(item), 
                           vendors: vendors_that_sell(item)}
      end
    end
  end

  def overstocked_items
    total_inventory.select do |item, details|
      details[:quantity] > 50 && details[:vendors].count > 1
    end.keys  
  end

  def sorted_item_list
    total_inventory.collect do |item, details|
      item.name if details[:quantity] > 0  
    end.sort  
  end
end