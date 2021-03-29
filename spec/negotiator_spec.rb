# frozen_string_literal: true

require_relative '../app/negotiator'
require_relative '../config/products'

describe Negotiator do
  before do
    @negotiator = Negotiator.new(PRODUCTS)
    @product = PRODUCTS.sample
  end

  describe 'print_products_table' do
    it 'print out Products table' do
      expect do
        @negotiator.print_products_table
      end.to output(/Please make your choice/).to_stdout
    end

    it 'print out allowed payments' do
      expect do
        @negotiator.print_allowed_payment_values
      end.to output(/Please provide payment\. Allowed values are/).to_stdout
    end

    it 'print out order result' do
      expect do
        @negotiator.print_order_result('Cola')
      end.to output(/Please take your 'Cola'/).to_stdout
    end

    it 'request product code' do
      allow(ARGF).to receive(:each).and_return('001')

      expect do
        @negotiator.read_product_code
      end.to output(/Just type the code of the product/).to_stdout

      expect(@negotiator.read_product_code).to eq('001')
    end

    it 'print that product is out of stock' do
      expect do
        @negotiator.print_out_of_stock(@product[:code])
      end.to output(/#{@product[:name]} is out of stock. Please select another one/).to_stdout
    end

    it 'print the change message with cents symbol' do
      expect do
        @negotiator.print_change_message(0.5)
      end.to output(/Please take you change: ¢0.5/).to_stdout
    end

    it 'print the change message with dollar symbol' do
      expect do
        @negotiator.print_change_message(2)
      end.to output(/Please take you change: \$2/).to_stdout
    end
  end
end
