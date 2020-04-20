class Discount < ApplicationRecord

  belongs_to :merchant

  validates_presence_of :percentage, :item_count

  validates_inclusion_of :percentage, in: 1..100, message: 'The discount percentage must be between 1 and 100.'
  validates :item_count, numericality: { greater_than: 0 }

  def status
    active? ? "active" : "inactive"
  end

end
