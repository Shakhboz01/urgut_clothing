module DataPopulation
  class PopulateSellers < ActiveInteraction::Base
    def execute
      sellers_data = JSON.parse(File.read('app/assets/javascripts/sellers.json'))
      sellers_data.each do |seller_data|
        create_seller(seller_data)
      end
    end

    private

    def create_seller(data)
      provider =
        Provider.find_or_create_by(
          name: data['seller_name'],
          phone_number: data['phone_number'],
          active: true
        )
      delivery_from_counterparty = DeliveryFromCounterparty.create!(
        provider: provider, user_id: User.first.id, price_in_usd: true
      )
      product = Product.find_or_create_by(
        name: 'TEST0', buy_price: 0.1, sell_price: 0.1, price_in_usd: true, unit: 0, product_category_id: ProductCategory.last.id
      )
      ProductEntry.create(
        paid_in_usd: true,
        buy_price: 0.1,
        sell_price: 0.2,
        delivery_from_counterparty_id: delivery_from_counterparty.id,
        storage_id: Storage.first.id
      )
      delivery_from_counterparty.update(
        total_price: data['in_usd'],
        status: :closed,
        total_paid: 0
      )
      product.update(active: false) if product.active
    end
  end
end
