class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  
  validates_presence_of :name,
                        :description,
                        :merchant_id
  validates :unit_price, presence: true, numericality: true

  before_destroy :destroy_invoice_if_only_item!, prepend: true
  #executes this method BEFORE the destroying the item 
  private
  #finds all invoices that this item is on and destroys the invoice
  #if the number of items on the invoice is 1
  def destroy_invoice_if_only_item!
    invoices.each do |invoice|
      invoice.destroy if invoice.items.size == 1
    end
  end
end
