class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    subtotal = quantity * price

    discounts = self.item.merchant.bulk_discounts
    discount = discounts.find_eligible_discount(quantity)

    discount ? discount.calculate_discount(subtotal) : subtotal
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
