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
        provider: provider, user_id: User.first.id, price_in_usd: true,
        total_price: data['in_usd'], status: :closed, total_paid: 0
      )
    end
  end
end
