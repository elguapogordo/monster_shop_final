require 'rails_helper'

RSpec.describe "merchant discount add", type: :feature do
  describe "as a merchant user" do
    before :each do
      @merchant1 = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user1 = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end

    context "i have a link to 'My Discounts' index page on my dashboard" do
      it "that has a link to 'Add Discount'" do
        visit '/merchant'

        click_link('My Discounts')
        expect(current_path).to eq('/merchant/discounts')
        click_link('Add Discount')
        expect(current_path).to eq('/merchant/discounts/new')
      end
    end

    context "when i click 'Add Discount' i see a form i can fill out and when i hit submit" do
      it "i am taken to my discounts index and can see the discount has been added" do
        visit '/merchant/discounts'

        expect(page).to_not have_content('10% off 10 or more items.')
        expect(page).to_not have_content('This discount is Active.')

        visit '/merchant/discounts/new'

        expect(page).to have_content('Add a new Discount')
        fill_in 'Percentage', with: 0
        fill_in 'item_count', with: 10
        click_button('Submit')

        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('The discount percentage must be between 1 and 100.')

        fill_in 'Percentage', with: 10
        fill_in 'item_count', with: 0
        click_button('Submit')

        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('must be greater than 0')

        fill_in 'Percentage', with: 10
        fill_in 'item_count', with: 10
        click_button('Submit')

        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('10% off 10 or more items.')
        expect(page).to have_content('This discount is Active.')
      end
    end
  end
end
