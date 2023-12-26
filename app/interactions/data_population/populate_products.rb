module DataPopulation
  class PopulateProducts < ActiveInteraction::Base
    def execute
      products_data = JSON.parse(File.read('app/assets/javascripts/products.json'))
      products_data.each do |product_data|
        create_products(product_data)
      end
    end

    private

    def create_products(data)
      product_category = ProductCategory.find_or_create_by(name: data['Склад'])
      name = data['Номенклатура']
      code = data['Код товара']
      initial_remaining = data['Остаток организации']
      price_in_usd = true
      buy_price =
        if data['Цена закупки'].present?
          data['Цена закупки']
        elsif data['Вал. цена закупки']
          data['Вал. цена закупки']
        elsif data['Цена отпуск.'].present?
          data['Цена отпуск.'] - percent_of(data['Цена отпуск.'])
        else
          0.0
        end

      sell_price =
        if data['Цена отпуск.'].present?
        data['Цена отпуск.']
        elsif data['Цена закупки'].present?
        percent_of(data['Цена закупки']) + data['Цена закупки']
        elsif data['Вал. цена закупки'].present?
        percent_of(data['Вал. цена закупки']) + data['Вал. цена закупки']
        else
        0
        end

      price_in_usd = false if buy_price > 2000
      pr = Product.create(
        name: name,
        code: code,
        product_category_id: product_category.id,
        price_in_usd: price_in_usd,
        buy_price: buy_price,
        sell_price: sell_price,
        initial_remaining: initial_remaining,
        unit: 0
      )
    end

    def percent_of(n)
      8 * n.to_f / 100.0
    end
  end
end
