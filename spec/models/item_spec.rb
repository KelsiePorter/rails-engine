require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'instance methods' do 
    describe 'destroy' do 
      it 'destroys an invoice when an item is deleted and the only item on the invoice' do 
        merchant = create(:merchant)
        customer = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice1 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 2)
        invoice2 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 2)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        ii1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 9, unit_price: 10)
        ii2 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 1, unit_price: 10)
        ii3 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item2.id, quantity: 2, unit_price: 8)

        expect(Invoice.count).to eq(2)
        expect(Item.count).to eq(2)
        expect(InvoiceItem.count).to eq(3)

        item1.destroy

        expect(Invoice.count).to eq(1)
        expect(Item.count).to eq(1)
        expect(InvoiceItem.count).to eq(1)
      end
    end
  end
end