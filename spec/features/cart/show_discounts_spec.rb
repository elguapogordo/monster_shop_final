require 'rails_helper'

RSpec.describe "cart show page displays item discounts", type: :feature do
  describe "as a user, when i visit my cart page and adjust item quantities" do
    it "the page correctly calculates and displays discounts every time quantities change" do
      mike = Merchant.create(name: "Mike\'s Mustache Emporium", address: '127 Main St', city: 'Denver', state: 'CO', zip: 80218)
      megan = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      user = User.create(name: 'Jesse Gietzen', address: '461 Ammo Dr', city: 'Boomtown', state: 'CO', zip: 80461, email: "user@example.com", password: "password_regular")
      item1 = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      item2 = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      item4 = mike.items.create!(name: 'Yosemite Sam', description: "Say yer prayers, rabbit!", price: 65, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
      item5 = mike.items.create!(name: 'Tom Selleck', description: "I'm not Burt Reynolds!", price: 35, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
      item6 = mike.items.create!(name: 'Wilford Brimley', description: "Diabeeetus!", price: 55, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
      item7 = mike.items.create!(name: 'Hulkster', description: "Brother!", price: 45, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 200 )
      discount1 = mike.discounts.create(percentage: 5, item_count: 5, active: true)
      discount2 = mike.discounts.create(percentage: 7, item_count: 10, active: true)
      discount3 = megan.discounts.create(percentage: 10, item_count: 5, active: true)
      discount4 = mike.discounts.create(percentage: 25, item_count: 1, active: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit item_path(item1)
      click_button 'Add to Cart'
      visit item_path(item2)
      click_button 'Add to Cart'
      visit item_path(item5)
      click_button 'Add to Cart'
      visit item_path(item6)
      click_button 'Add to Cart'
      visit item_path(item7)
      click_button 'Add to Cart'

      visit '/cart'
      expect(page).to_not have_content("bulk discount has been applied to this item.")

      within "#item-#{item1.id}" do
        4.times do
          click_button('More of This!')
        end
        expect(page).to have_content("Subtotal: $90.00")
        expect(page).to have_content("10% bulk discount has been applied to this item.")
      end

      within "#item-#{item2.id}" do
        expect(page).to_not have_content("bulk discount has been applied to this item.")
        click_button('More of This!')
        expect(page).to have_content("Subtotal: $100.00")
        expect(page).to_not have_content("bulk discount has been applied to this item.")
      end

      within "#item-#{item5.id}" do
        expect(page).to_not have_content("bulk discount has been applied to this item.")
        3.times do
          click_button('More of This!')
        end
        expect(page).to have_content("Subtotal: $140.00")
        expect(page).to_not have_content("bulk discount has been applied to this item.")
      end

      within "#item-#{item6.id}" do
        expect(page).to_not have_content("bulk discount has been applied to this item.")
        8.times do
          click_button('More of This!')
        end
        expect(page).to have_content("Subtotal: $470.25")
        expect(page).to have_content("5% bulk discount has been applied to this item.")
        5.times do
          click_button('More of This!')
        end
        expect(page).to have_content("Subtotal: $716.10")
        expect(page).to have_content("7% bulk discount has been applied to this item.")
      end

      within "#item-#{item7.id}" do
        expect(page).to_not have_content("bulk discount has been applied to this item.")
        6.times do
          click_button('More of This!')
        end
        expect(page).to have_content("Subtotal: $299.25")
        expect(page).to have_content("5% bulk discount has been applied to this item.")
      end
    end
  end
end
