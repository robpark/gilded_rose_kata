def conjured?(item)
  item.name.match /conjured/i
end

def brie?(item)
  item.name.match /brie/i
end

def backstage_pass?(item)
  item.name.match /backstage passes/i
end

def sulfuras?(item)
  item.name.match /sulfuras/i
end

module Normal
  def update_quality
    self.quality -= 1
  end

  def update_sell_in
    self.sell_in -= 1
  end
end

module Brie
  def update_quality
    self.quality += 1
  end

  def update_sell_in
    self.sell_in -= 1
  end
end

module BackstagePass
  def update_quality
    self.quality += 1
    if self.sell_in < 11
      self.quality += 1
    end
    if self.sell_in < 6
      self.quality += 1
    end
  end

  def update_sell_in
    self.sell_in -= 1
  end
end

module Sulfuras
  def update_quality

  end
end

module Conjured
  def update_quality
    self.quality -= 2
  end

  def update_sell_in
    self.sell_in -= 1
  end
end

def qualify(item)
  case item.name
    when /brie/i
      item.extend Brie
    when /backstage pass/i
      item.extend BackstagePass
    when /sulfuras/i
      item.extend Sulfuras
    when /conjured/i
      item.extend Conjured
    else
      item.extend Normal
  end
end

def update_quality(items)
  items.each do |item|
    qualify item
    item.update_quality
    unless sulfuras? item
      item.update_sell_in
    end
    if item.sell_in < 0
      unless brie? item
        unless backstage_pass? item
          if item.quality > 0
            unless sulfuras? item
              item.quality -= 1
              if conjured? item
                item.quality -= 1
              end
            end
          end
        else
          item.quality = 0
        end
      else
        item.quality += 1
      end
    end
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

