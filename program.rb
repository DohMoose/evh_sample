#!/usr/bin/env ruby
require_relative 'credit_card_checker'

cards = ARGF.read 

puts CreditCardChecker.check_cards(cards)
