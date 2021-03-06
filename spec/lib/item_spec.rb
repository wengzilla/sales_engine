require 'spec_helper.rb'

describe SalesEngine::Item do

  let(:inv_item_one){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "3",
                                                    :invoice_id => "1", :item_id => "1", :updated_at => "2012-2-19") }
  let(:inv_item_two){ SalesEngine::InvoiceItem.new( :unit_price => "1", :quantity => "3",
                                                    :invoice_id => "2", :item_id => "2", :updated_at => "2012-9-09") } 
  let(:inv_item_three){ SalesEngine::InvoiceItem.new( :unit_price => "10", :quantity => "4",
                                                    :invoice_id => "3", :item_id => "1", :updated_at => "2012-1-01") }
  let(:item_one){ SalesEngine::Item.new( :id => 1, :merchant_id => 1 ) }
  let(:item_two){ SalesEngine::Item.new( :id => 2, :merchant_id => 2 )}
  let(:inv_one)   { SalesEngine::Invoice.new( :id => "1", :customer_id => "1",
                                   :created_at => "2012-2-19" ) }
  let(:inv_two)   { SalesEngine::Invoice.new( :id => "2", :customer_id => "2",
                                   :created_at => "2012-9-09" ) }
  let(:inv_three)   { SalesEngine::Invoice.new( :id => "3", :customer_id => "2",
                                   :created_at => "2012-1-01" ) }
  let(:merchant_one){ SalesEngine::Merchant.new( :id => "1" )}
  let(:merchant_two){ SalesEngine::Merchant.new( :id => "2" )}
  let(:tr_one)   { SalesEngine::Transaction.new( :invoice_id => "1") }
  let(:tr_two)   { SalesEngine::Transaction.new( :invoice_id => "2", :result => "failure") }
  let(:tr_three) { SalesEngine::Transaction.new( :invoice_id => "2", :result => "success") }
  let(:tr_four)  { SalesEngine::Transaction.new( :invoice_id => "3", :result => "success") }
  let(:transaction_list) {SalesEngine::Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]}

  describe "#invoice_items" do
    it "returns a collection of invoice_items associated with the item instance" do
      SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
      item_one.invoice_items.should == [ inv_item_one, inv_item_three ]
    end

    context "when an invoice has an invalid invoice id" do
      it "returns empty array" do
        SalesEngine::Database.instance.invoice_item_list = [ inv_item_two ]
        item_one.invoice_items.should be_empty
      end
    end
  end

  describe "#merchant" do
    it "returns an instance of merchant associated with the item" do
      SalesEngine::Database.instance.merchant_list = [ merchant_one, merchant_two ]
      item_one.merchant.should == merchant_one
    end
  end

  describe ".most('revenue')" do
    it "returns the top x items ranked by revenue generated by that item" do
      SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
      SalesEngine::Database.instance.item_list = [ item_two, item_one ]
      SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
      transaction_list
      SalesEngine::Item.most("revenue", 1).should == [ item_one ]
    end

    context "when there are no invoice_items" do
      it "returns nil" do
        SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two ]
        SalesEngine::Database.instance.invoice_item_list = [ ]
        SalesEngine::Item.most("revenue", 2).should be_empty
      end
    end
  end

  describe ".most('quantity')" do
    it "returns the top x items ranked by total numbers sold" do
      SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
      SalesEngine::Database.instance.item_list = [ item_two, item_one ]
      SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
      transaction_list
      SalesEngine::Item.most("quantity", 2).should == [ item_one, item_two ]
    end

    context "when there are no invoice_items" do
      it "returns nil" do
        SalesEngine::Database.instance.invoice_item_list = [ ]
        SalesEngine::Item.most("quantity", 2).should be_empty
      end
    end
  end

  describe "#best_day" do
    it "returns the day on which we sold the most of that item" do
      SalesEngine::Database.instance.invoice_item_list = [ inv_item_one, inv_item_two, inv_item_three ]
      SalesEngine::Database.instance.item_list = [ item_two, item_one ]
      SalesEngine::Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
      transaction_list
      item_one.best_day.should == Date.parse("2012-1-01")
    end
  end

end