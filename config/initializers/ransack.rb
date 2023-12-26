# Custom ransack predicate to simplify query for date range
# wiki https://github.com/activerecord-hackery/ransack/wiki/Custom-Predicates
Ransack.configure do |config|
  config.add_predicate 'end_of_day_lteq',
                       arel_predicate: 'lteq',
                       formatter: proc { |v| v.end_of_day }

  config.add_predicate 'blank_if_ticked',
                       arel_predicate: 'eq_any',
                       compounds: false,
                       type: :boolean,
                       validator: proc { |v| v },
                       formatter: proc { [nil, ''.freeze].freeze }

  config.add_predicate 'power',
                       arel_predicate: 'eq_any',
                       compounds: false,
                       type: :boolean,
                       validator: proc { |v| v },
                       formatter: proc { %w[payment_operator manager project_manager admin accountant analyst].freeze }
end
