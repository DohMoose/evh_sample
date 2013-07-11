class CreditCardChecker
  def initialize(card)
    @card = card
  end
    
  def type
    case 
    when (length == 15 and (prefix(2) == '34' or prefix(2) == '37'))
      'AMEX'
    when (length == 16 and prefix(4) == '6011')
      'Discover'
    when (length == 16 and ['51','52','53'].include?(prefix(2)))
      'MasterCard'
    end
  end
end
