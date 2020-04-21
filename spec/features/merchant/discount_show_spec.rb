require 'rails_helper'

RSpec.describe "merchant discount show", type: :feature do
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

    context "when i visit my discount index and click a discount id i go to that discount show page" do
      it "and i see that discount's information, as well as links to edit and delete that discount" do
        visit "/merchant/discounts/"

        click_link("Discount ID: #{@discount1.id}")
        expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")
        expect(page).to have_content("Discount #{@discount1.id}")
        expect(page).to have_content("Discount: #{@discount1.percentage}")
        expect(page).to have_content("Minimum Items: #{@discount1.item_count}")
        expect(page).to have_content("Discount Status: #{@discount1.status}")
        expect(page).to have_content("Created: #{@discount1.created_at}")
        expect(page).to have_content("Last Updated: #{@discount1.updated_at}")
        expect(page).to have_link("Edit Discount")
        expect(page).to have_link("Delete Discount")
      end
    end
  end
end
