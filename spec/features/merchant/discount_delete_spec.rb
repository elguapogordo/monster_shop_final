require 'rails_helper'

RSpec.describe "deleting discounts", type: :feature do
  describe "as a merchant user" do
    describe "when i visit a discount show page and click the link to 'Delete Discount'" do
      it "the discount is removed and i am taken back to the discount index page and it is gone" do
        merchant1 = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        merchant2 = Merchant.create(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
        user1 = merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'meganexample.com', password: 'securepassword')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
        discount0 = merchant2.discounts.create(percentage: 7, item_count: 7, active: true)
        discount1 = merchant1.discounts.create(percentage: 5, item_count: 5, active: false)
        discount2 = merchant1.discounts.create(percentage: 10, item_count: 15, active: true)

        visit "/merchant/discounts"

        expect(page).to have_content("Discount ID: #{discount1.id}")
        expect(page).to have_content("Discount ID: #{discount2.id}")

        visit "/merchant/discounts/#{discount2.id}"

        click_link("Delete Discount")
        expect(current_path).to eq("/merchant/discounts")

        merchant1.reload

        visit "/merchant/discounts"

        expect(page).to have_content("Discount ID: #{discount1.id}")
        expect(page).to_not have_content("Discount ID: #{discount2.id}")
      end
    end
  end
end
