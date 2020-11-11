require "rails_helper"

describe "As a merchant employee" do
  describe "on my bulk discount index page" do
    before :each do
      @merchant1 = create(:merchant)
      @discount1 = create(:discount, merchant: @merchant1)
      @employee1 = create(:employee, merchant: @merchant1, role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee1)

      @quantity = 25
      @percentage = 10
    end

    it "I can edit my discount through a edit link" do
      # Feature works on local host but test wont update @discount1
      visit merchant_discounts_path
      click_link "Update Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")

      fill_in :bulk_quantity, with: @quantity
      fill_in :percentage_discount, with: @percentage

      click_button "Update Bulk Discount"
      @discount1.reload

      expect(current_path).to eq("/merchant/discounts")
      expect(@discount1.bulk_quantity).to eq(25)
      expect(@discount1.percentage_discount).to eq(10)
      # expect(page).to have_content(@quantity)
      # expect(page).to have_content(@percentage)
    end

    it "I can't edit the dicount with bad or no information" do
      visit "/merchant/discounts/#{@discount1.id}/edit"

      click_button "Update Bulk Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
      expect(page).to have_content("bulk_quantity: [\"is not a number\"]")
      expect(page).to have_content("percentage_discount: [\"Discount must be percentage from 1 - 100\"]")
      expect(page).to have_button('Update Bulk Discount')

      #-----------------------------------------

      visit "/merchant/discounts/#{@discount1.id}/edit"

      fill_in :bulk_quantity, with: -1
      fill_in :percentage_discount, with: -10
      click_button "Update Bulk Discount"


      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
      expect(page).to have_content("bulk_quantity: [\"must be greater than 0\"]")
      expect(page).to have_content("percentage_discount: [\"Discount must be percentage from 1 - 100\"]")
      expect(page).to have_button("Update Bulk Discount")
    end
  end
end
