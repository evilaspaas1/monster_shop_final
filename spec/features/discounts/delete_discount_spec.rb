require "rails_helper"

describe "As a merchant employee" do
  it "I can delete a discount from my bulk discount index page" do
    merchant1 = create(:merchant)
    discount1 = create(:discount, merchant: merchant1, bulk_quantity: 10, percentage_discount: 5)
    discount2 = create(:discount, merchant: merchant1, bulk_quantity: 20, percentage_discount: 10)
    discount3 = create(:discount, merchant: merchant1, bulk_quantity: 30, percentage_discount: 15)
    employee1 = create(:employee, role: 1, merchant: merchant1)

    visit login_path
    fill_in 'Email', with: employee1.email
    fill_in 'Password', with: employee1.password
    click_button 'Log In'

    visit merchant_discounts_path

    within ".discount-#{discount2.id}" do
      click_button "Delete"
    end

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_css("section.discount-#{discount1.id}")
    expect(page).to have_css("section.discount-#{discount3.id}")
    expect(page).to_not have_css("section.discount-#{discount2.id}")
  end
end
