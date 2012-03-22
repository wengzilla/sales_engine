module SalesEngine
  class Customer
    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    CUSTOMER_ATTS = [
     "id",
     "first_name",
     "last_name",
     "created_at",
     "updated_at"
     ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    CUSTOMER_ATTS.each do |att|
      define_singleton_method ("find_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.customer_list.detect do |customer|
          customer.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    CUSTOMER_ATTS.each do |att|
      define_singleton_method ("find_all_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.customer_list.select do |customer| 
          customer if customer.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end
  end
end