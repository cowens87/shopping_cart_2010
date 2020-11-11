class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new {|hash_obj, key| hash_obj[key] = 0}
  end
end