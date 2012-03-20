class Merchant
  attr_accessor :id, :name, :created_at, :updated_at

  def initialize(attributes)
    self.id = attributes[:id]
    self.name = attributes[:name]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end
end