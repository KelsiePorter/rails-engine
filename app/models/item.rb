class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  
  validates_presence_of :name,
                        :description,
                        :merchant_id
  validates :unit_price, presence: true, numericality: true
end
