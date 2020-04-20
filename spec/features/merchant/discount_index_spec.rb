require 'rails_helper'

RSpec.describe "merchant discount index", type: :feature do
  describe "as a merchant user" do
    before :each do
      @merchant1 = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user1 = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      @discount1 = @merchant1.discounts.create(percentage: 5, item_count: 5, active: false)
      @discount2 = @merchant1.discounts.create(percentage: 10, item_count: 15, active: true)
    end

    context "when i click 'My Discounts' on my dashboard, i go to my discounts index" do
      it "and i can view all of my discounts" do
        visit '/merchant'
        click_link 'My Discounts'

        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('My Discounts')

        within "#discount-#{@discount1.id}" do
          expect(page).to have_content('5% off 5 or more items.')
          expect(page).to have_content('This discount is inactive.')
        end

        within "#discount-#{@discount2.id}" do
          expect(page).to have_content('10% off 15 or more items.')
          expect(page).to have_content('This discount is active.')
        end
      end
    end
  end
end
