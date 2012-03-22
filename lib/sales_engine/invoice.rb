require 'csv'
require 'ruby-debug'

module SalesEngine
  class Invoice
    INVOICE_ATTS = [ 
      "id",
      "customer_id",
      "merchant_id",
      "status",
      "created_at",
      "updated_at"
    ]

    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

    def initialize(attributes)
      self.id = attributes[:id]
      self.customer_id = attributes[:customer_id]
      self.merchant_id = attributes[:merchant_id]
      self.status = attributes[:status]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def transactions
      SalesEngine::Transaction.find_by_invoice_id(self.id)
    end

    INVOICE_ATTS.each do |att|
      define_singleton_method ("find_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.invoice_list.detect do |invoice|
          invoice.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    INVOICE_ATTS.each do |att|
      define_singleton_method ("find_all_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.invoice_list.select do |invoice|
          invoice if invoice.send(att.to_sym).downcase == param.downcase
        end
      end
    end
    
  end
end