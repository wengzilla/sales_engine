require 'spec_helper.rb'

describe SalesEngine::Merchant do
  let(:merchant_one){ SalesEngine::Merchant.new( :id => "1" )}
  let(:merchant_three){ SalesEngine::Merchant.new( :id => "3" )}

  describe "#invoices" do
    let(:inv_one)   { mock(SalesEngine::Invoice) }
    let(:inv_two)   { mock(SalesEngine::Invoice) }
    let(:inv_three) { mock(SalesEngine::Invoice) }

    before(:each) do
      inv_one.stub(:merchant_id).and_return("1")
      inv_two.stub(:merchant_id).and_return("1")
      inv_three.stub(:merchant_id).and_return("2")
      invoices = [ inv_one, inv_two, inv_three ]

      SalesEngine::Database.instance.stub(:invoice_list).and_return(invoices)
    end

    it "returns a collection of invoices associated with the merchant" do
      merchant_one.invoices.should == [ inv_one, inv_two ]
    end

    context "when a merchant has no invoices" do
      it "returns an empty array" do
        merchant_three.invoices.should be_empty
      end
    end
  end

  describe "#items" do
    let(:item_one)   { mock(SalesEngine::Item) }
    let(:item_two)   { mock(SalesEngine::Item) }
    let(:item_three) { mock(SalesEngine::Item) }

    before(:each) do
      item_one.stub(:merchant_id).and_return("1")
      item_two.stub(:merchant_id).and_return("2")
      item_three.stub(:merchant_id).and_return("1")
      items = [ item_one, item_two, item_three ]

      SalesEngine::Database.instance.stub(:item_list).and_return(items)
    end

    it "returns a collection of items associated with the merchant" do
      merchant_one.items.should == [ item_one, item_three ]
    end

    context "when a merchant has no items" do
      it "returns an empty array" do
        merchant_three.items.should be_empty
      end
    end
  end

  describe "#revenue" do
    let(:inv_one)     { mock(SalesEngine::Invoice) }
    let(:inv_two)     { mock(SalesEngine::Invoice) }

    before(:each) do
      inv_one.stub(:invoice_revenue).and_return(BigDecimal.new("100"))
      inv_two.stub(:invoice_revenue).and_return(BigDecimal.new("100"))
    end

    context "when there are invoice_items" do
      it "returns total revenue for merchant" do
        merchant_one.stub( {:invoices => [ inv_one, inv_two ]} )
        merchant_one.revenue.should == 200
      end
    end
    context "when there are no invoice items" do
      it "returns 0" do
        merchant_one.stub( {:invoices => []} )
        merchant_one.revenue.should == 0
      end
    end
  end

  # describe ".dates_by_revenue" do
  #   #sum all invoice items and divide by number of invoices
  #   it "returns an array of date objs in descending order of revenue" do
  #     Database.instance.invoice_item_list = [ inv_item_one, inv_item_two ]
  #     Database.instance.invoice_list = [ inv_one, inv_two, inv_three ]
  #     Database.instance.transaction_list = [ tr_one, tr_two, tr_three, tr_four ]
  #     Invoice.dates_by_revenue.should == [  ]
  #   end
  # end
end