# frozen_string_literal: true

require_relative '../app/order'
require_relative '../config/products'

describe Order do
  before do
    @product = PRODUCTS.sample
  end

  context 'newly created order without balance' do
    before do
      @order = Order.new(@product[:code])
    end

    it 'paid_up? returns false' do
      expect(@order.paid_up?).to be_falsey
    end

    it 'positive_balance? returns false' do
      expect(@order.positive_balance?).to be_falsey
    end

    it 'no_payment_provided_yet? returns true' do
      expect(@order.no_payment_provided_yet?).to be_truthy
    end
  end

  context 'newly created order with balance' do
    before do
      @order = Order.new(@product[:code], 5)
    end

    it 'paid_up? returns false' do
      expect(@order.paid_up?).to be_falsey
    end

    it 'positive_balance? returns true' do
      expect(@order.positive_balance?).to be_truthy
    end

    it 'no_payment_provided_yet? returns false' do
      expect(@order.no_payment_provided_yet?).to be_falsey
    end

    it 'no_payment_provided_yet? returns true in case 0 provided payment' do
      order = Order.new(@product[:code], 0)
      expect(order.no_payment_provided_yet?).to be_truthy
    end
  end

  describe 'Order closing' do
    context 'closed order' do
      it 'closed? return true for paid up Order with no plus balance' do
        order = Order.new(@product[:code])
        order.pay(@product[:price])
        expect(order.closed?).to be_truthy
      end

      it 'closed? return true for closed by user order' do
        order = Order.new(@product[:code])
        order.close
        expect(order.closed?).to be_truthy
      end
    end

    context 'not closed order' do
      it 'closed? return false for paid up Order with no plus balance' do
        order = Order.new(@product[:code])
        expect(order.closed?).to be_falsey
      end

      it 'closed? return false for closed by user order' do
        order = Order.new(@product[:code])
        expect(order.closed?).to be_falsey
      end
    end
  end
end
