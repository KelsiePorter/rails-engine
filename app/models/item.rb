class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  
  validates_presence_of :name,
                        :description,
                        :merchant_id
  validates :unit_price, presence: true, numericality: true

  before_destroy :destroy_invoice_if_only_item!, prepend: true

  private

  def destroy_invoice_if_only_item!
    invoices.each do |invoice|
      invoice.destroy if invoice.items.size == 1
    end
  end
end
