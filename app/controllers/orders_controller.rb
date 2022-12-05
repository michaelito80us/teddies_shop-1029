class OrdersController < ApplicationController
  def create
    @teddy = Teddy.find(params[:teddy_id])
    order = Order.create!(teddy_sku: @teddy.sku, amount: @teddy.price, state: 'pending')

    redirect_to order_payment_path(order)
  end

  def show
    @order = Order.find(params[:id])

    if @order.state == 'pending'
      r = WxPay::Service.order_query(out_trade_no: "teddies_shop_1029_#{@order.id}")
      unless r[:raw]['xml']['trade_state'] == 'NOTPAY'
        @order.state = 'paid'
        @order.save!
      end
    end
  end

  def index
    @orders = Order.order(created_at: :desc)
  end
end
