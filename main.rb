# frozen_string_literal: true

require_relative 'app/vending_machine'
require_relative 'config/products'

VendingMachine.new(PRODUCTS).vend
