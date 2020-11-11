require "rails_helper"
include ActionView::Helpers::TextHelper
include ActionView::Helpers::NumberHelper

RSpec.describe "Apply Discount in Cart Spec" do
  before :each do
    @merchant1 = create(:merchant)
    @item1 = create(:item, merchant: @merchant1, price: 10, inventory: 10)
    @item2 = create(:item, merchant: @merchant1)
    @discount1 = create(:discount, merchant: @merchant1, bulk_quantity: 5, percentage_discount: 10)
    @discount2 = create(:discount, merchant: @merchant1, bulk_quantity: 10, percentage_discount: 20)

    @discount_message1 = "Discount applied: #{@discount1.percentage_discount}% off for #{pluralize(@discount1.bulk_quantity, @item1.name)}!"
    @discount_subtotal1 = "Subtotal: #{number_to_currency((@item1.price * 5) * 0.01 * (100 - @discount1.percentage_discount))}"

    @discount_message2 = "Discount applied: #{@discount2.percentage_discount}% off for #{pluralize(@discount2.bulk_quantity, @item1.name)}!"
    @discount_subtotal2 = "Subtotal: #{number_to_currency(@discount2.calculate_discount(@item1.price * 10))}"

    [@item1, @item2].each do |item|
      4.times do
        visit item_path(item)
        click_button "Add to Cart"
      end
    end

    visit "/cart"
  end

  describe "As a visitor" do
    describe "When I add a bulk quantity of items to my cart" do
      it "The price is adjusted with a percentage discount" do
        within "#item-#{@item1.id}" do
          expect(page).to have_content("Subtotal: #{number_to_currency(@item1.price * 4)}")
          expect(page).to_not have_content(@discount_message1)
        end

        visit item_path(@item1)
        click_button "Add to Cart"
        visit "/cart"

        # discount for item above the bulk_quantity
        within "#item-#{@item1.id}" do
          expect(page).to have_content(@discount_subtotal1)
          expect(page).to have_content(@discount_message1)
        end

        # no discount for item below the bulk_quantity
        within "#item-#{@item2.id}" do
          expect(page).to have_content("Subtotal: #{number_to_currency(@item2.price * 4)}")
          expect(page).to_not have_content("Discount applied")
        end

        # testing that the total updates with correct price
        expect(page).to_not have_content("Total: $450.00")
        expect(page).to have_content("Total: $445.00")
      end

      it "Bulk discounts only apply to specific merchants with that discount" do
        merchant2 = create(:merchant)
        item3 = create(:item, merchant: merchant2)

        5.times do
          visit item_path(item3)
          click_button "Add to Cart"
        end

        visit "/cart"

        within "#item-#{item3.id}" do
          expect(page).to have_content("Subtotal: #{number_to_currency(item3.price * 5)}")
          expect(page).to_not have_content("Discount applied")
        end
      end
    end

    describe "When I adjust the quantity of items in my cart" do
      it "The discount is automatically added when I meet the bulk quantity requirement" do
        within "#item-#{@item1.id}" do
          expect(page).to have_content("Subtotal: #{number_to_currency(@item1.price * 4)}")
          expect(page).to_not have_content(@discount_message1)

          click_button("More of This!")

          expect(page).to have_content(@discount_subtotal1)
          expect(page).to have_content(@discount_message1)
        end
      end

      it "The discount is automatically removed when I dont meet the bulk quantity requirement" do
        visit item_path(@item1)
        click_button "Add to Cart"
        visit "/cart"

        within "#item-#{@item1.id}" do
          expect(page).to have_content(@discount_subtotal1)
          expect(page).to have_content(@discount_message1)

          click_button("Less of This!")

          expect(page).to have_content("Subtotal: #{number_to_currency(@item1.price * 4)}")
          expect(page).to_not have_content(@discount_message1)
        end
      end

      it "Applies the higher discount when I meet the higher bulk quantity requirement" do

        within "#item-#{@item1.id}" do
          click_button "More of This!"

          expect(page).to have_content(@discount_subtotal1)
          expect(page).to have_content(@discount_message1)
        end

        within "#item-#{@item1.id}" do
          5.times { click_button("More of This!") }

          expect(page).to have_content(@discount_subtotal2)
          expect(page).to have_content(@discount_message2)

          expect(page).to_not have_content(@discount_subtotal1)
          expect(page).to_not have_content(@discount_message1)
        end
      end

      it "The discount is automatically adjusted when I meet a lower bulk quantity" do

        within "#item-#{@item1.id}" do
          6.times {click_button("More of This!")}

          expect(page).to have_content(@discount_subtotal2)
          expect(page).to have_content(@discount_message2)
        end

        within "#item-#{@item1.id}" do
          5.times { click_button("Less of This!") }

          expect(page).to have_content(@discount_subtotal1)
          expect(page).to have_content(@discount_message1)

          expect(page).to_not have_content(@discount_subtotal2)
          expect(page).to_not have_content(@discount_message2)
        end
      end
    end
  end
end
