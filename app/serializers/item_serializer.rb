class ItemSerializer
  include JSONAPI::Serializer
  attributes :description, :unit_price
end