class CreditCardChecker
  attr_accessor :card
  def initialize(card)
    @card = card.gsub(/\s+/, "")
  end
    
  def type
    case 
    when (length == 15 and (prefix(2) == '34' or prefix(2) == '37'))
      'AMEX'
    when (length == 16 and prefix(4) == '6011')
      'Discover'
    when (length == 16 and ['51','52','53'].include?(prefix(2)))
      'MasterCard'
    when ((length == 13 or length == 16) and prefix(1) == '4')
      'Visa'
    end
  end

  def length
    card.length
  end

  def prefix(characters)
    card[0...characters]
  end

  #Starting with the next to last digit and continuing with every other digit going back to the beginning of the card, double the digit
  def luhn_step_1
    doubled = ''
    card.chars.reverse.each_with_index do |digit, index|
      doubled = (index.odd? ? (digit.to_i * 2).to_s : digit) + doubled
    end
    doubled
  end

  #Sum all doubled and untouched digits in the number. For digits greater than 9 you will need to split them and sum the independently
  def luhn_step_2
    #ripped from http://rosettacode.org/wiki/Sum_digits_of_an_integer#Ruby
    luhn_step_1.split(//).inject(0) {|z, x| z + x.to_i(10)}
  end

  def luhn_step_3
    (luhn_step_2) % 10 == 0
  end
  alias :validated_with_luhn :luhn_step_3

  def valid?
    validated_with_luhn and !type.nil?
  end

end
