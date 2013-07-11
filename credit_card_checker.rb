class CreditCardChecker
  def initialize(card)
    @card = card
  end
    
  def type
    case 
    when (length == 15 and prefix(2) == "34")
      "AMEX"
    end
  end
end
