# frozen_string_literal: true

require_relative '../app/validator'
require_relative '../config/products'

describe Validator do
  before do
    @validator = Validator.new
    @products_codes = PRODUCTS.map { |product| product[:code] }
    @cash_amount = Validator::VALID_CASH_INPUTS
  end

  describe 'valid_code?' do
    it 'returns true' do
      expect(@validator.valid_code?(@products_codes.sample)).to be_truthy
    end

    it 'returns false' do
      expect(@validator.valid_code?('do not exist')).to be_falsey
    end
  end

  describe 'valid_cash_amount?' do
    it 'returns true' do
      expect(@validator.valid_cash_amount?(@cash_amount.sample)).to be_truthy
    end

    it 'returns false' do
      expect(@validator.valid_cash_amount?(0)).to be_falsey
    end
  end
end
