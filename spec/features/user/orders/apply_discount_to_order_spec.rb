require "rails_helper"
include ActionView::Helpers::TextHelper
include ActionView::Helpers::NumberHelper

describe "Apply Discount to Order Spec" do
  before :each do
    @merchant1 = create(:merchant)
    @item1 = create(:item, merchant: @merchant1, price: 10, inventory: 10)
    @item2 = create(:item, merchant: @merchant1, price: 10, inventory: 10)
    @discount1 = create(:discount, merchant: @merchant1, bulk_quantity: 5, percentage_discount: 10)

    @user = create(:user)
    @order = create(:order, user: @user)
    @order_item1 = @order.order_items.create!(item: @item1, price: @item1.price, quantity: 5, fulfilled: false)
    @order_item2 = @order.order_items.create!(item: @item2, price: @item2.price, quantity: 4, fulfilled: false)

    @discount_subtotal1 = "#{number_to_currency(@discount1.calculate_discount(@item1.price * 5))}"
    @discount_message1 = "Discount applied: #{@discount1.percentage_discount}% off for #{pluralize(@discount1.bulk_quantity, @order_item1.item.name)}!"

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe "As a Registered User" do
    describe "When I have an order with an item eligible for a bulk discount" do
      it "I see the discounted price on my order show page" do
        visit "/profile/orders/#{@order.id}"

        expect(page).to_not have_content("Total: $90.00")
        expect(page).to have_content("Total: $85.00")

        within "#order-item-#{@order_item1.id}" do
          expect(page).to have_content("Subtotal: #{@discount_subtotal1}")
          expect(page).to have_content(@discount_message1)
        end

        within "#order-item-#{@order_item2.id}" do
          expect(page).to have_content("Subtotal: #{number_to_currency(@order_item2.price * @order_item2.quantity)}")
          expect(page).to_not have_content("Discount applied:")
        end
      end
    end
  end
end
