require_relative 'credit_card_checker'

describe CreditCardChecker do
  describe 'cleaning input' do
    it 'should remove whitespace' do
      ccc = CreditCardChecker.new '3423 2342 2342'
      ccc.card.should eql '342323422342'
    end
  end

  describe 'finding type' do
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
    it "step 1: double every second digit, starting from the end" do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.luhn_step_1.should eql '8408042264106148183'
    end

    it "step 2: add up all the digits" do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.stub(:luhn_step_1).and_return('8408042264106148183')
      ccc.luhn_step_2.should eql 70
    end

    it "step3: true when luhn_step_2 is multiple of 10" do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.stub(:luhn_step_2).and_return(70)
      ccc.luhn_step_3.should be_true
    end

    it "step3: false when luhn_step_2 is not multiple of 10" do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.stub(:luhn_step_2).and_return(74)
      ccc.luhn_step_3.should be_false
    end

    it "aliases luhn_step_3 as validated_with_luhn" do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.stub(:luhn_step_2).and_return(70)
      ccc.validated_with_luhn.should be_true
    end
  end


  describe 'is valid' do
    it 'when validated_with_luhn is true and type is not nil' do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.should_receive(:validated_with_luhn).and_return(true)
      ccc.should_receive(:type).and_return('VISA')
      ccc.should be_valid
    end
  end

  describe 'is not valid' do
    it 'when validated_with_luhn is false and type is not nil' do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.should_receive(:validated_with_luhn).and_return(false)
      ccc.should_receive(:type).and_return('VISA')
      ccc.should_not be_valid
    end

    it 'when validated_with_luhn is true and type is nil' do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.stub(:validated_with_luhn).and_return(true)
      ccc.should_receive(:type).and_return(nil)
      ccc.should_not be_valid
    end

    it 'when validated_with_luhn is false and type is nil' do
      ccc = CreditCardChecker.new '4408 0412 3456 7893'
      ccc.stub(:validated_with_luhn).and_return(false)
      ccc.should_receive(:type).and_return(nil)
      ccc.should_not be_valid
    end
  end
end
