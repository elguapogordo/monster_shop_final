class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    if top_discount(item_id).nil?
      count_of(item_id) * Item.find(item_id).price
    else
      (count_of(item_id) * Item.find(item_id).price * discount_factor(item_id)).round(2)
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def top_discount(item_id)
    Item.find(item_id)
      .merchant
      .discounts
      .where("active = ? AND item_count <= ?", true, count_of(item_id))
      .order(percentage: :desc)
      .pluck(:percentage)
      .first
  end

  def discount_factor(item_id)
    (100.0 - top_discount(item_id)) / 100
  end

end
