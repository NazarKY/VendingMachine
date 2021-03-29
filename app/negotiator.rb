# frozen_string_literal: true

require_relative 'validator'

# Responsible for communication with the User
class Negotiator
  LONG_NAME_LENGTH = 6

  attr_accessor :products

  def initialize(products)
    @products = products
    @validator = Validator.new
  end

  def print_products_table
    puts 'Please make your choice.'

    puts "Code \t Name \t\t\t Price \n"
    @products.each do |product|
      puts "#{product[:code]}\t #{format_name(product[:name])} #{format_price(product[:price])}\n"
    end
  end

  def print_allowed_payment_values
    puts "Please provide payment. Allowed values are #{Validator::VALID_CASH_INPUTS.to_s}"
  end

  def print_order_result(name)
    puts "\nPlease take your '#{name}'"
  end

  def print_balance(balance)
    puts "Balance: #{balance}"
  end

  def read_product_code
    puts "\nJust type the code of the product:"

    ARGF.each do |input|
      code = input.strip
      return code if @validator.valid_code?(code)

      puts 'You entered incorrect product code. Please try again:'
    end
  end

  def read_payment_value
    ARGF.each do |input|
      payment = input.strip.to_f
      return payment if @validator.valid_cash_amount?(payment)

      puts 'You provided incorrect Payment value. Please try again:'
    end
  end

  def make_new_order?(balance)
    new_order_question(balance)

    ARGF.each do |input|
      if input.strip == 'Y'
        print_allowed_payment_values
        return true
      elsif input.strip == 'N'
        puts 'Thanks for choosing the VendingMachine :)'
        return false
      else
        puts 'You entered incorrect answer. Please try again, only Y/N:'
      end
    end
  end

  def print_out_of_stock(code)
    clear_terminal
    selected_product = PRODUCTS.detect { |product| product[:code] == code }
    puts "#{selected_product[:name]} is out of stock. Please select another one"
  end

  def print_change_message(change)
    clear_terminal
    money_sign = change >= 1 ? '$' : '¢'
    puts "Please take you change: #{money_sign}#{change}"
  end

  private

  def new_order_question(balance)
    clear_terminal
    puts "\nImportant!"
    puts "You have Positive Balance: #{balance}"
    puts "Vending Machine doesn't have enough change."
    puts 'Would you like to make a new order? Please type Y/N.'
    puts '* in case you chose N(No) the extra provided payment will be lost'
  end

  def format_name(name)
    return "#{name} \t\t" if name.size > LONG_NAME_LENGTH

    "#{name} \t\t\t"
  end

  def format_price(price)
    "$#{price.to_f}"
  end

  def clear_terminal
    system('clear') || system('cls')
  end
end
