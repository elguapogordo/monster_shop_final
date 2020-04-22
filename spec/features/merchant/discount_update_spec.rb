require 'rails_helper'

RSpec.describe "updating discounts", type: :feature do
  describe "as a merchant user" do
    before :each do
      @merchant1 = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant2 = Merchant.create(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user1 = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      @discount0 = @merchant2.discounts.create(percentage: 7, item_count: 7, active: true)
      @discount1 = @merchant1.discounts.create(percentage: 5, item_count: 5, active: false)
      @discount2 = @merchant1.discounts.create(percentage: 10, item_count: 15, active: true)
    end

    describe "change discount amounts" do
      context "when i visit a discount show page and click 'Edit Discount' i am taken to a form" do
        it "and when i hit 'Submit' i am taken back to the discount show page and my changes have been saved" do
          visit "/merchant/discounts/#{@discount2.id}"
          expect(page).to have_content("Discount: 10 percent")
          expect(page).to have_content("Minimum Items: 15")

          click_link("Edit Discount")

          expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")
          expect(page).to have_content('Edit Discount')
          fill_in 'Percentage', with: 0
          fill_in 'item_count', with: 10
          click_button('Submit')

          expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")
          expect(page).to have_content('The discount percentage must be between 1 and 100')
          fill_in 'Percentage', with: 8
          fill_in 'item_count', with: 0
          click_button('Submit')

          expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")
          expect(page).to have_content('Item count must be greater than 0')
          fill_in 'Percentage', with: 8
          fill_in 'item_count', with: 10
          click_button('Submit')

          expect(current_path).to eq("/merchant/discounts/#{@discount2.id}")
          expect(page).to have_content("Discount: 8 percent")
          expect(page).to have_content("Minimum Items: 10")
        end
      end
    end

    describe "toggle discount status" do
      context "when i visit my discount index, i see all of my discounts and their status" do
        it "and i can toggle their status with a link next to that discount" do
          visit "/merchant/discounts"

          within "#discount-#{@discount1.id}" do
            expect(page).to have_content('This discount is Inactive.')
            expect(page).to have_link("Activate")
            click_link("Activate")
          end

          @merchant1.reload
          visit "/merchant/discounts"

          within "#discount-#{@discount1.id}" do
            expect(page).to have_link("Deactivate")
          end

          within "#discount-#{@discount2.id}" do
            expect(page).to have_content('This discount is Active.')
            expect(page).to have_link("Deactivate")
            click_on("Deactivate")
          end

          @merchant1.reload
          visit "/merchant/discounts"

          within "#discount-#{@discount2.id}" do
            expect(page).to have_link("Activate")
          end
        end
      end
    end
  end
end
