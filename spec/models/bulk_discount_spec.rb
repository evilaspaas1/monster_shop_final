require "rails_helper"

describe BulkDiscount do
  describe "validations" do
    it { should validate_numericality_of(:bulk_quantity).is_greater_than(0) }
    it { should validate_inclusion_of(:percentage_discount)
      .in_range(1..100)
      .with_message("Discount must be percentage from 1 - 100") }
  end

  describe "associations" do
    it { should belong_to :merchant }
  end

  describe "class methods" do
    it "::find_eligible_discount()" do
      merchant1 = create(:merchant)
      discount3 = create(:discount, merchant: merchant1, bulk_quantity: 30, percentage_discount: 12)
      discount1 = create(:discount, merchant: merchant1, bulk_quantity: 10, percentage_discount: 5)
      discount2 = create(:discount, merchant: merchant1, bulk_quantity: 20, percentage_discount: 8)

      expect(merchant1.bulk_discounts.find_eligible_discount(5)).to eq(nil)
      expect(merchant1.bulk_discounts.find_eligible_discount(9)).to eq(nil)

      expect(merchant1.bulk_discounts.find_eligible_discount(10)).to eq(discount1)
      expect(merchant1.bulk_discounts.find_eligible_discount(19)).to eq(discount1)

      expect(merchant1.bulk_discounts.find_eligible_discount(20)).to eq(discount2)
      expect(merchant1.bulk_discounts.find_eligible_discount(29)).to eq(discount2)

      expect(merchant1.bulk_discounts.find_eligible_discount(30)).to eq(discount3)
    end
  end

  describe "instance methods" do
    it "#calculate_discount()" do
      merchant1 = create(:merchant)
      discount1 = create(:discount, merchant: merchant1, bulk_quantity: 5, percentage_discount: 10)

      bulk_order = {quantity: 5, price: 10}
      subtotal = bulk_order[:quantity] * bulk_order[:price]

      expect(discount1.calculate_discount(subtotal)).to eq(45.0)
    end
  end
end
