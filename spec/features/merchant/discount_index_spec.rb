require "rails_helper"

describe "As a Merchant employee" do
  describe "When i visit my merchant dashboard" do
    before :each do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)

      @discount1 = create(:discount, merchant: @merchant1, bulk_quantity: 10, percentage_discount: 5)
      @discount2 = create(:discount, merchant: @merchant1, bulk_quantity: 20, percentage_discount: 10)

      @employee1 = create(:employee, role: 1, merchant: @merchant1)
      @employee2 = create(:employee, role: 1, merchant: @merchant2)
    end

    it "I can click a link to my bulk discounts index page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee1)

      visit merchant_dashboard_path
      click_link "Bulk Discounts"

      expect(current_path).to eq("/merchant/discounts")

      discounts = [@discount1, @discount2]
      discounts.each do |discount|
        within ".discount-#{discount.id}" do
          expect(page).to have_content("Quantity: #{discount.bulk_quantity}")
          expect(page).to have_content("Discount: #{discount.percentage_discount}%")
          expect(page).to have_content("Created At: #{discount.created_at.to_s(:short)}")
        end
      end
    end
    it "If I Do not have any discounts I see a message telling me so" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee2)

      visit merchant_discounts_path

      expect(page).to have_content("You have no discounts.")
    end
  end
end
