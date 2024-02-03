class InitialRemainingBasedOnPack < ActiveInteraction::Base
  object :pack
  symbol :action, default: :create
  integer :product_entry_amount
  string :code

  def execute
    pack.product_size_colors.each do |psc|
      amount = psc.amount * product_entry_amount
      product = Product.find_by_code(code)
      return errors.add(:base, 'cannot find product without a code') if product.nil?

      name = "#{psc.color.name} | #{product.name} | #{psc.size.name}"
      product = Product.find_or_create_by(
        color: psc.color,
        size: psc.size,
        code: psc.color,
        pack: pack
      )
      product.update(name: name) if product.name.nil?
      case action
      when :create
        product.increment!(:initial_remaining, amount)
      when :destroy
        product.decrement!(:initial_remaining, amount)
      else
        Rails.logger.warn('Unhandled action')
      end
    end
  end
end
