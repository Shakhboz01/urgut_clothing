module ProductSells
  class FindProductEntriesUntilAmount < ActiveInteraction::Base
    decimal :amount
    object :pack

    def execute
      unsold_product_entries = pack.product_entries.unsold
      remaining_amount = amount
      product_entry_ids = []
      unsold_product_entries.order(:created_at).each do |product_entry|
        difference = product_entry.amount - product_entry.amount_sold
        if difference <= remaining_amount
          product_entry_ids << product_entry.id
          remaining_amount -= difference
        else
          product_entry_ids << product_entry.id
          break
        end
      end

      ProductSells::HandleAmountSold.run!(
        product_entry_ids: product_entry_ids,
        pack: pack,
        amount: amount,
      )
    end
  end
end
