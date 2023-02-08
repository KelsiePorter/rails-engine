class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :description,
                        :merchant_id
  validates :unit_price, presence: true, numericality: true
end
