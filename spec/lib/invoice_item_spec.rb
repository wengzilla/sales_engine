require 'spec_helper.rb'

describe SalesEngine::InvoiceItem do

  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                                    :invoice_id => "1",  :item_id => "1" ) }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                                    :invoice_id => "2", :item_id => "2" ) } 
  let(:inv_one)   { SalesEngine::Invoice.new( :id => "1", :customer_id => "1",
                                   :created_at => "2012-2-19" ) }
  let(:inv_two)   { SalesEngine::Invoice.new( :id => "2", :customer_id => "2",
                                   :created_at => "2012-9-09" ) }
  let(:item_one){ SalesEngine::Item.new( :id => "1") }
  let(:item_two){ SalesEngine::Item.new( :id => "2") }
  let(:tr_one)   { SalesEngine::Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { SalesEngine::Transaction.new( :invoice_id => "2", :result => "failure") }
  let(:tr_three) { SalesEngine::Transaction.new( :invoice_id => "2", :result => "success") }
  let(:tr_four)  { SalesEngine::Transaction.new( :invoice_id => "3", :result => "failure") }

  describe "#invoice" do
    it "returns an instance of invoice associated with the instance" do
      SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]
      inv_item_one.invoice.should == inv_one
    end

    context "when an invoice has an invalid invoice id" do
      it "returns nil" do
        SalesEngine::Database.instance.invoice_list = [ inv_two ]
        inv_item_one.invoice.should be_nil
      end
    end
  end

  describe "#item" do
    it "returns an instance of item associated with the invoice item" do
      SalesEngine::Database.instance.item_list = [ item_one, item_two ]
      inv_item_one.item.should == item_one
    end

    context "when an invoice has an invalid item id" do
      it "returns nil" do
        SalesEngine::Database.instance.item_list = [ item_two ]
        inv_item_one.item.should be_nil
      end
    end
  end

  # describe "is_successful?" do
  #   context "when an invoice item is on an invoice with at least one successful transaction" do 
  #     it "returns one successful transaction" do
  #       SalesEngine::Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
  #       SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]
  #       inv_item_two.is_successful?.should == tr_three
  #     end
  #   end
    
  #   context "when an invoice item is on an invoice that has no successful transactions" do 
  #     it "returns nil" do
  #       SalesEngine::Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
  #       SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]
  #       inv_item_one.is_successful?.should be_nil
  #     end
  #  end
  # end
end