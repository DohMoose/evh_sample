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
end
