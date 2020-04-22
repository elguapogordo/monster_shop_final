require 'rails_helper'

RSpec.describe Discount do

  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :item_count}
    it {should validate_inclusion_of(:percentage).
      in_range(1..100).
      with_message('The discount percentage must be between 1 and 100.')}
    it {should validate_numericality_of(:item_count).
      is_greater_than(0)}
  end

  describe 'Instance Methods' do
    before :each do
      @merchant1 = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user1 = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = @merchant1.discounts.create(percentage: 5, item_count: 5, active: true)
      @discount2 = @merchant1.discounts.create(percentage: 10, item_count: 10, active: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end

    it '.status' do
      expect(@discount1.status).to eq('Active')
      expect(@discount2.status).to eq('Inactive')
    end

  end

end
