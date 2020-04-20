class AddDefaultToDiscounts < ActiveRecord::Migration[5.1]
  def change
    change_column_default :discounts, :active, true
  end
end
