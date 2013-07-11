require_relative 'credit_card_checker'

describe CreditCardChecker do
  describe "validating type" do
    it "should find AMEX when starting with 34 and with length of 15" do
      ccc = CreditCardChecker.new '34344'
      ccc.stub(:length).and_return(15)
      ccc.should_receive(:prefix).with(2).and_return("34")
      ccc.type.should eql "AMEX"
    end
    it "should find AMEX when starting with 37 and with length of 15" do
      ccc = CreditCardChecker.new '34344'
      ccc.stub(:length).and_return(15)
      ccc.should_receive(:prefix).twice.with(2).and_return("37")
      ccc.type.should eql "AMEX"
    end
    it "should find Discover when starting with 6011 and with length of 16" do
      ccc = CreditCardChecker.new '6011'
      ccc.stub(:length).and_return(16)
      ccc.should_receive(:prefix).with(4).and_return("6011")
      ccc.type.should eql "Discover"
    end
  end
end
