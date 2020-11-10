require "rails_helper"

describe "As a merchant employee" do
  describe "When I visit my bulk discount index page" do
    before :each do
      @merchant1 = create(:merchant)
      @discount1 = create(:discount, merchant: @merchant1)
      @employee1 = create(:employee, merchant: @merchant1, role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee1)
    end

    it "I see a link to create a new bulk discount" do
      visit merchant_discounts_path

      click_link "Create A Discount"

      expect(BulkDiscount.count).to eq(1)

      fill_in :bulk_quantity, with: 30
      fill_in :percentage_discount, with: 15
      click_button "Create A Discount"

      expect(BulkDiscount.count).to eq(2)
      expect(current_path).to eq(merchant_discounts_path)
    end

    it "I can't fill the form in incorrectly and create the discount" do
      visit new_merchant_discount_path

      expect(BulkDiscount.count).to eq(1)

      fill_in :bulk_quantity, with: 30
      # fill_in :percentage_discount, with: 15
      click_button "Create A Discount"

      expect(BulkDiscount.count).to eq(1)
      expect(current_path).to eq(new_merchant_discount_path)

      #-------------------------------------------------------

      fill_in :bulk_quantity, with: -1
      fill_in :percentage_discount, with: 10
      click_button "Create Bulk Discount"

      expect(BulkDiscount.count).to eq(1)
      expect(current_path).to eq(new_merchant_discount_path)

      #-------------------------------------------------------

      fill_in :bulk_quantity, with: 40
      fill_in :percentage_discount, with: -10
      click_button "Create Bulk Discount"

      expect(BulkDiscount.count).to eq(1)
      expect(current_path).to eq(new_merchant_discount_path)
    end
  end
end
