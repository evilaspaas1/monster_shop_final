class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_inclusion_of :percentage_discount, in: 1..100, message:  "Discount must be percentage from 1 - 100"
  validates :bulk_quantity, numericality: { greater_than: 0 }

  def self.find_eligible_discount(item_quantity)
    order(:bulk_quantity).where("bulk_quantity <= ?", item_quantity).last
  end

  def calculate_discount(price)
    price * (100 - percentage_discount) * 0.01
  end
end
