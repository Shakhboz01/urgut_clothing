require 'socket'
escpos_image_path = $LOAD_PATH.find { |p| p =~ /escpos-image/ }
$LOAD_PATH.delete(escpos_image_path)
# require the base escpos gem, which requires its own escpos/helpers
require 'escpos'
# re-add and require the escpos-image gem to Ruby's LOAD_PATH
$LOAD_PATH.insert($LOAD_PATH.index {|p| p =~ /escpos/}, escpos_image_path)
require 'escpos/image'

module ProductSells
  class PrintReceipt < ActiveInteraction::Base
    include ActionView::Helpers
    include ApplicationHelper

    object :sale

    def execute
      image = Escpos::Image.new 'app\assets\images\logo.png', {
        processor: "ChunkyPng",
        extent: true
      }
      header_format = "%-20s %-10s %-10s\n" # Adjust column widths as needed
      basic_format = "%-10s %-10s %-10s\n" # Adjust column widths as needed
      printer = Escpos::Printer.new
      printer << basic_format % ["Sotuvchi: #{Translit.convert sale.user.name}", sale.created_at, "№ #{sale.id}"]
      printer << Escpos::Helpers.center(image.to_escpos)
      printer << Escpos::Helpers.center(Escpos::Helpers.big("Urgut kiyim\n\n"))
      sale.product_sells.each do |product_sell|
        quantity_and_price = "#{product_sell.amount} * #{product_sell.sell_price * product_sell.amount}"
        total_price = product_sell.amount
        product_name = Translit.convert(product_sell.product.name)
        body_format = "%-20s %-10s %-10s\n"
        printer << body_format % [product_name, quantity_and_price, total_price]
      end

      # printer << Escpos::Helpers.right("Услуга: 10%".encode('UTF-8'))
      printer << Escpos::Helpers.center(Escpos::Helpers.bold("Jami: #{currency_convert(sale.price_in_usd, sale.total_price)}\n"))
      printer << Escpos::Helpers.center(Escpos::Helpers.bold("Jami to'landi: #{currency_convert(sale.price_in_usd, sale.total_paid)}\n"))
      printer << Escpos::Helpers.center("97-930-24-54\n")
      # printer << Escpos::Helpers.encode("This is UTF-8 to ISO-8859-2 text: ěščřžýáíéúů", encoding: "ISO-8859-2")

      socket = TCPSocket.new "192.168.100.102", 9100
      socket.write printer.to_escpos
      socket.close
    end
  end
end
