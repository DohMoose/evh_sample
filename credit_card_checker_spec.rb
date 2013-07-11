require_relative 'credit_card_checker'

describe CreditCardChecker do
  describe 'cleaning input' do
    it 'should remove whitespace' do
      ccc = CreditCardChecker.new '3423 2342 2342'
      ccc.card.should eql '342323422342'
    end
  end

  describe 'validating type' do
    it 'should find AMEX when starting with 34 and with length of 15' do
      ccc = CreditCardChecker.new '34344'
      ccc.stub(:length).and_return(15)
      ccc.should_receive(:prefix).with(2).and_return('34')
      ccc.type.should eql 'AMEX'
    end

    it 'should find AMEX when starting with 37 and with length of 15' do
      ccc = CreditCardChecker.new '34344'
      ccc.stub(:length).and_return(15)
      ccc.should_receive(:prefix).twice.with(2).and_return('37')
      ccc.type.should eql 'AMEX'
    end

    it 'should find Discover when starting with 6011 and with length of 16' do
      ccc = CreditCardChecker.new '6011'
      ccc.stub(:length).and_return(16)
      ccc.should_receive(:prefix).with(4).and_return('6011')
      ccc.type.should eql 'Discover'
    end

    it 'should find MasterCard when starting with 51-53 and with length of 16' do
      ccc = CreditCardChecker.new '533434'
      ccc.stub(:length).and_return(16)
      ccc.stub(:prefix).with(4).and_return('324')
      (51..53).each do |prefix|
        ccc.should_receive(:prefix).with(2).and_return(prefix.to_s)
        ccc.type.should eql 'MasterCard'
      end
    end

    it 'should find Visa when starting with 4 and with length of 16' do
      ccc = CreditCardChecker.new '533434'
      ccc.stub(:length).and_return(16)
      ccc.stub(:prefix).with(4).and_return('324')
      ccc.stub(:prefix).with(2).and_return('32')
      ccc.should_receive(:prefix).with(1).and_return('4')
      ccc.type.should eql 'Visa'
    end

    it 'should find Visa when starting with 4 and with length of 13' do
      ccc = CreditCardChecker.new '533434'
      ccc.stub(:length).and_return(13)
      ccc.stub(:prefix).with(4).and_return('324')
      ccc.stub(:prefix).with(2).and_return('32')
      ccc.should_receive(:prefix).with(1).and_return('4')
      ccc.type.should eql 'Visa'
    end
  end


  describe "Luhn algorithm" do
    it "double every second digit, starting from the end" do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.luhn_step_1.should eql '8408042264106148183'
    end
  end
  
end
