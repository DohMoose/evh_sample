if ARGV.length != 1
  puts <<-EOF
  Please provide a file name
  Usage: 
     ruby program.rb <filename>
EOF
else
  require_relative 'credit_card_checker'

  cards = ARGF.read 

  puts CreditCardChecker.check_cards(cards)
end
