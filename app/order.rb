# frozen_string_literal: true

require_relative '../config/products'

# Represents User`s Order
class Order
  attr_accessor :product_code
  attr_reader :product_name, :payment_balance

  def initialize(code, provided_payment = 0)
    selected_product = PRODUCTS.detect { |product| product[:code] == code }
    @product_code = code
    @product_name = selected_product[:name]
    @product_price = selected_product[:price]
    @provided_payment = provided_payment

    update_payment_balance
  end

  def pay(payment_amount)
    @provided_payment += payment_amount
    update_payment_balance
  end

  def no_payment_provided_yet?
    @provided_payment.zero?
  end

  def paid_up?
    return false if @payment_balance.nil?

    @payment_balance.zero?
  end

  def positive_balance?
    return false if @payment_balance.nil?

    @payment_balance.positive?
  end

  def closed?
    @closed_by_user || paid_up? && !positive_balance?
  end

  def close
    @closed_by_user = true
  end

  private

  def update_payment_balance
    @payment_balance = @provided_payment - @product_price
  end
end
