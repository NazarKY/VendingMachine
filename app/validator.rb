# frozen_string_literal: true

require_relative '../config/products'

# Validates User`s input
class Validator
  VALID_CASH_INPUTS = [0.25, 0.5, 1, 2, 5].freeze

  def initialize
    @valid_products_codes = PRODUCTS.map { |product| product[:code] }
  end

  def valid_code?(code)
    @valid_products_codes.include?(code)
  end

  def valid_cash_amount?(amount)
    VALID_CASH_INPUTS.include?(amount)
  end
end
