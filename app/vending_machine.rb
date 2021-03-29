# frozen_string_literal: true

require_relative 'negotiator'
require_relative 'order'

# Responsible for communication with the User
class VendingMachine
  LONG_NAME_LENGTH = 6
  START_ITEM_COUNT = 1
  CHANGE_VALUES = [0.25, 0.5].freeze

  def initialize(products)
    @products = products
    @negotiator = Negotiator.new(@products)
    @products_counter = load_new_products_portion(@products)
    @change_state = { 0.25 => 0, 0.5 => 0 } # only coins can be used for change
  end

  def vend
    loop do
      new_order_flow unless @order

      @order.positive_balance? ? paid_flow : not_paid_flow

      if @order.closed?
        @negotiator.print_order_result(@order.product_name)
        break
      end
    end
  end

  private

  def new_order_flow(left_payment_balance = 0)
    @negotiator.print_products_table

    code = @negotiator.read_product_code
    if out_of_stock?(code)
      @negotiator.print_out_of_stock(code)
      new_order_flow(left_payment_balance)
    else
      create_order(code, left_payment_balance)
    end
  end

  def create_order(code, left_payment_balance)
    @order = Order.new(code, left_payment_balance)
    update_product_count(code)
  end

  def not_paid_flow
    @negotiator.print_balance(@order.payment_balance) unless @order.paid_up?
    manage_payment_input
  end

  def paid_flow
    @negotiator.print_order_result(@order.product_name)

    return unless @order.positive_balance?

    balance = @order.payment_balance
    if valid_change_value?(balance)
      @negotiator.print_change_message(balance)
      @order.close
    else
      new_oder = @negotiator.make_new_order?(balance)
      new_oder ? new_order_flow(balance) : @order.close
    end
  end

  def manage_payment_input
    if @order.no_payment_provided_yet? || !@order.positive_balance?
      @negotiator.print_allowed_payment_values
    end

    return if @order.paid_up?

    payment_value = @negotiator.read_payment_value
    update_available_change_state(payment_value)
    @order.pay(payment_value)
  end

  # Manage the Products state =========

  def load_new_products_portion(products)
    products.each_with_object({}) do |product, result|
      code_value = product[:code]
      result[code_value] = START_ITEM_COUNT
    end
  end

  def update_product_count(code)
    @products_counter[code] = @products_counter[code] - 1
    update_products
  end

  def out_of_stock?(code)
    @products_counter[code].zero?
  end

  def update_products
    @products = @products.reject { |product| out_of_stock?(product[:code]) }
    @negotiator.products = @products
  end

  # Manage the Money state =========

  def update_available_change_state(value, add = true)
    return if !add && @change_state[value].zero? || !can_be_change_value?(value)

    add ? @change_state[value] += 1 : @change_state[value] -= 1
  end

  def can_be_change_value?(value)
    CHANGE_VALUES.include?(value)
  end

  def valid_change_value?(balance)
    total_sum = 0
    @change_state.each do |state|
      key, value = state
      total_sum += key * value
    end
    total_sum >= balance
  end
end
