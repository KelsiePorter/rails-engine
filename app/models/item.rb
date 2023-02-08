class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id
end
