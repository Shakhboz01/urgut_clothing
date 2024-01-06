module DataPopulation
  class PopulateBuyers < ActiveInteraction::Base
    def execute
      buyers_data = JSON.parse(File.read('app/assets/javascripts/buyers2.json'))
      buyers_data.each do |buyer_data|
        create_buyers(buyer_data)
      end
    end

    private

    def create_buyers(data)
      buyer =
        Buyer.find_or_create_by(
          name: data['buyer_name'],
          phone_number: data['phone_number'],
          active: true
        )
      if !data['in_uzs'].nil?
        sale = Sale.create!(
          buyer: buyer, user_id: User.first.id, price_in_usd: false
        )

        sale.update(
          total_price: data['in_uzs'],
          status: :closed,
          total_paid: 0
        )
      end

      if !data['in_usd'].nil?
        sale = Sale.create!(
          buyer: buyer, user_id: User.first.id, price_in_usd: true
        )

        sale.update(
          total_price: data['in_usd'],
          status: :closed,
          total_paid: 0
        )
      end
    end
  end
end
