class PaymentsController < ApplicationController
  def show
    @order = Order.where(state: 'pending').find(params[:order_id])

    pay_params = {
      body: @order.teddy_sku,
      out_trade_no: "teddies_shop_1029_#{@order.id}",
      total_fee: @order.amount_cents,
      spbill_create_ip: Socket.ip_address_list.detect(&:ipv4_private?).ip_address,
      notify_url: Rails.application.credentials.dig(:wechat, :notify_url),
      trade_type: 'NATIVE'
    }
    r = WxPay::Service.invoke_unifiedorder pay_params

    if r.success?
      @qr = RQRCode::QRCode.new(r['code_url']).as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        standalone: true,
        module_size: 8
      )
    else
      # for debugging in console
      p 'response unsuccessful'
      p r
    end
  end

  def wx_notify
    result = Hash.from_xml(request.body.read)['xml']
    logger.info result.inspect
    if WxPay::Sign.verify?(result)
      order_id = result['out_trade_no'].split('_').to_i
      Order.find(order_id).update(payment: result.to_json, state: 'paid')
      render xml: { return_code: 'SUCCESS', return_msg: 'OK' }.to_xml(root: 'xml', dasherize: false)
    else
      render xml: { return_code: 'FAIL', return_msg: 'Signature Error' }.to_xml(root: 'xml', dasherize: false)
    end
  end
end
